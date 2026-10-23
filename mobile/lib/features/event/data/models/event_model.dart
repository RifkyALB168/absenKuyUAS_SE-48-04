import '../../../../core/utils/geo.dart';
import '../../domain/entities/event.dart';

/// Bentuk JSON kegiatan yang dipertukarkan dengan backend REST.
///
/// Kontrak field (snake_case) yang harus disamakan dengan endpoint:
/// - `GET /events?group_id=` dan `GET /groups/:id/events` -> array kegiatan
/// - `GET /events/:id` -> satu objek kegiatan
/// - `POST /groups/:id/events` dan `PUT /events/:id` -> kirim [toJson],
///   balas satu objek kegiatan
///
/// Implementasi backend belum ada (folder `backend/` masih kosong), jadi nama
/// field di bawah adalah usulan. Bila skema MySQL berbeda, hanya berkas ini
/// yang perlu disesuaikan.
class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.groupId,
    required super.title,
    required super.location,
    required super.startAt,
    required super.endAt,
    super.description,
    super.status,
    super.createdBy,
    super.createdAt,
  });

  /// Membaca satu kegiatan dari respons backend.
  factory EventModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> location =
        (json['location'] as Map?)?.cast<String, dynamic>() ?? const {};

    return EventModel(
      id: json['id']?.toString() ?? '',
      groupId: json['group_id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: EventLocation(
        point: GeoPoint(
          _toDouble(location['latitude']),
          _toDouble(location['longitude']),
        ),
        radiusMeters: _toDouble(
          location['radius_meters'],
          fallback: EventLocation.defaultRadiusMeters,
        ),
        address: location['address'] as String?,
        placeName: location['place_name'] as String?,
      ),
      startAt: _parseDate(json['start_at']),
      endAt: _parseDate(json['end_at']),
      status: EventStatus.fromName(json['status'] as String?),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at'] == null
          ? null
          : _parseDate(json['created_at']),
    );
  }

  /// Membungkus entitas domain menjadi model, mis. sebelum dikirim ke backend.
  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      groupId: event.groupId,
      title: event.title,
      description: event.description,
      location: event.location,
      startAt: event.startAt,
      endAt: event.endAt,
      status: event.status,
      createdBy: event.createdBy,
      createdAt: event.createdAt,
    );
  }

  /// Field yang dikirim ke backend saat membuat atau mengubah kegiatan.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': {
        'latitude': location.point.latitude,
        'longitude': location.point.longitude,
        'radius_meters': location.radiusMeters,
        'address': location.address,
        'place_name': location.placeName,
      },
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'status': status.name,
    };
  }
}

double _toDouble(Object? value, {double fallback = 0}) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

DateTime _parseDate(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}
