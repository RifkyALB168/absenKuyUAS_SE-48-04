const maxPhotoBytes = 2 * 1024 * 1024;

export function registerAttendanceRoute(router, { authenticate, multer, pool, photoStore }) {
  const upload = multer({
    storage: multer.memoryStorage(),
    limits: { fileSize: maxPhotoBytes, files: 1, fields: 4, fieldSize: 64 },
  }).single('photo');
  const handler = createAttendanceHandler({ pool, photoStore });

  router.post('/events/:id/attendances', authenticate, (req, res, next) => {
    upload(req, res, (error) => {
      if (error) return res.status(400).json({ code: 'INVALID_PHOTO' });
      return handler(req, res, next);
    });
  });
}

export function createAttendanceHandler({ pool, photoStore }) {
  return async (req, res, next) => {
    const userId = req.user?.id;
    const eventId = req.params.id;
    const requestId = req.get('Idempotency-Key');
    if (!userId) return res.status(401).json({ code: 'UNAUTHENTICATED' });
    if (!/^[1-9]\d{0,19}$/.test(eventId ?? '') || !/^[a-f0-9]{32}$/.test(requestId ?? '')) {
      return res.status(400).json({ code: 'INVALID_REQUEST' });
    }

    const receivedAt = new Date();
    let connection;
    let photoKey;
    let committing = false;
    try {
      connection = await pool.getConnection();
      await connection.beginTransaction();

      const [[event]] = await connection.execute(
        `SELECT e.lat, e.lng, e.radius_m,
                DATE_FORMAT(e.window_open, '%Y-%m-%dT%H:%i:%s.%fZ') AS window_open,
                DATE_FORMAT(e.window_close, '%Y-%m-%dT%H:%i:%s.%fZ') AS window_close
           FROM events e
           JOIN user_groups g ON g.id = e.group_id AND g.status = 'active'
           JOIN memberships m ON m.group_id = g.id AND m.user_id = ? AND m.status = 'active'
           JOIN users u ON u.id = m.user_id AND u.status = 'active' AND u.email_verified_at IS NOT NULL
          WHERE e.id = ? AND e.status = 'published'
          FOR UPDATE`,
        [userId, eventId],
      );
      if (!event) return res.status(403).json({ code: 'ATTENDANCE_FORBIDDEN' });

      const [[previous]] = await connection.execute(
        'SELECT id, request_id FROM attendances WHERE event_id = ? AND user_id = ?',
        [eventId, userId],
      );
      if (previous) {
        return requestId === previous.request_id
          ? res.status(200).json({ id: previous.id, status: 'hadir' })
          : res.status(409).json({ code: 'ALREADY_ATTENDED' });
      }

      const result = validateAttendance(event, req.body, receivedAt);
      if (result.code) return res.status(422).json(result);
      const photoType = imageType(req.file?.buffer);
      if (!photoType) return res.status(400).json({ code: 'INVALID_PHOTO' });

      photoKey = await photoStore.put(req.file.buffer, photoType);
      const recordedAt = receivedAt.toISOString().slice(0, 23).replace('T', ' ');
      const [insert] = await connection.execute(
        `INSERT INTO attendances
          (event_id, user_id, lat, lng, jarak_m, accuracy_m, photo_path, is_mocked, status, request_id, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, FALSE, 'hadir', ?, ?)`,
        [eventId, userId, result.latitude, result.longitude, result.distance_m,
          result.accuracy, photoKey, requestId, recordedAt],
      );
      committing = true;
      await connection.commit();
      return res.status(201).json({ id: insert.insertId, status: 'hadir' });
    } catch (error) {
      if (photoKey && !committing) {
        try {
          await photoStore.remove(photoKey);
        } catch {
          // Rekonsiliasi penyimpanan privat membersihkan file tanpa referensi.
        }
      }
      return next(error);
    } finally {
      if (connection) {
        try {
          await connection.rollback();
          connection.release();
        } catch {
          connection.destroy();
        }
      }
    }
  };
}

export function validateAttendance(event, fields, now) {
  const open = Date.parse(event.window_open);
  const close = Date.parse(event.window_close);
  const radius = numberField(event.radius_m);
  const eventLat = numberField(event.lat);
  const eventLng = numberField(event.lng);
  if (!Number.isFinite(open) || !Number.isFinite(close) || close <= open ||
      !validCoordinates(eventLat, eventLng) || radius <= 0 || !Number.isFinite(radius)) {
    return { code: 'EVENT_UNAVAILABLE' };
  }
  if (+now < open || +now >= close) return { code: 'WINDOW_CLOSED' };
  if (fields?.is_mocked === 'true') return { code: 'MOCKED_LOCATION' };
  if (fields?.is_mocked !== 'false') return { code: 'INVALID_LOCATION' };

  const latitude = numberField(fields.latitude);
  const longitude = numberField(fields.longitude);
  const accuracy = numberField(fields.accuracy);
  if (!validCoordinates(latitude, longitude)) return { code: 'INVALID_LOCATION' };
  if (!Number.isFinite(accuracy) || accuracy <= 0 || accuracy > radius) {
    return { code: 'INACCURATE_LOCATION' };
  }
  const distance = distanceInMeters(eventLat, eventLng, latitude, longitude);
  if (distance > radius) {
    return { code: 'OUT_OF_RANGE', distance_m: distance, radius_m: radius };
  }
  return { latitude, longitude, accuracy, distance_m: distance };
}

function numberField(value) {
  if (typeof value === 'number') return value;
  return typeof value === 'string' && value.trim() ? Number(value) : NaN;
}

function validCoordinates(lat, lng) {
  return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
}

function distanceInMeters(lat1, lng1, lat2, lng2) {
  const rad = Math.PI / 180;
  const a = Math.sin((lat2 - lat1) * rad / 2) ** 2 +
    Math.cos(lat1 * rad) * Math.cos(lat2 * rad) * Math.sin((lng2 - lng1) * rad / 2) ** 2;
  return 6371000 * 2 * Math.asin(Math.sqrt(Math.min(1, Math.max(0, a))));
}

function imageType(bytes) {
  if (!Buffer.isBuffer(bytes) || bytes.length < 12 || bytes.length > maxPhotoBytes) return null;
  if (bytes[0] === 255 && bytes[1] === 216 && bytes[2] === 255) return 'image/jpeg';
  if (bytes.subarray(0, 8).equals(Buffer.from('89504e470d0a1a0a', 'hex'))) return 'image/png';
  if (bytes.toString('ascii', 0, 4) === 'RIFF' && bytes.toString('ascii', 8, 12) === 'WEBP') {
    return 'image/webp';
  }
  return null;
}
