import 'dart:math' as math;

class AttendanceEvent {
  const AttendanceEvent({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.opensAt,
    required this.closesAt,
    this.isDemo = false,
  });

  final String id;
  final double latitude;
  final double longitude;
  final int radiusMeters;
  final DateTime opensAt;
  final DateTime closesAt;
  final bool isDemo;

  void checkWindow(DateTime now) {
    if (id.isEmpty ||
        !validCoordinates(latitude, longitude) ||
        radiusMeters <= 0 ||
        !opensAt.isBefore(closesAt)) {
      throw const AttendanceBlocked(AttendanceIssue.eventUnavailable);
    }
    if (now.isBefore(opensAt) || !now.isBefore(closesAt)) {
      throw const AttendanceBlocked(AttendanceIssue.windowClosed);
    }
  }

  double checkLocation(AttendancePosition position) {
    if (position.isMocked) {
      throw const AttendanceBlocked(AttendanceIssue.mockedLocation);
    }
    if (!validCoordinates(position.latitude, position.longitude)) {
      throw const AttendanceBlocked(AttendanceIssue.locationUnavailable);
    }
    if (!position.accuracy.isFinite ||
        position.accuracy <= 0 ||
        position.accuracy > radiusMeters) {
      throw const AttendanceBlocked(AttendanceIssue.inaccurateLocation);
    }
    final distance = distanceInMeters(
      latitude,
      longitude,
      position.latitude,
      position.longitude,
    );
    if (distance > radiusMeters) {
      throw AttendanceBlocked(AttendanceIssue.outOfRange, distance: distance);
    }
    return distance;
  }
}

class AttendancePosition {
  const AttendancePosition({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.isMocked,
  });

  final double latitude;
  final double longitude;
  final double accuracy;
  final bool isMocked;
}

enum AttendanceIssue {
  eventUnavailable,
  windowClosed,
  gpsDisabled,
  permissionDenied,
  permissionDeniedForever,
  inaccurateLocation,
  locationUnavailable,
  mockedLocation,
  outOfRange,
}

class AttendanceBlocked implements Exception {
  const AttendanceBlocked(this.issue, {this.distance});

  final AttendanceIssue issue;
  final double? distance;
}

bool validCoordinates(double latitude, double longitude) =>
    latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;

double distanceInMeters(double lat1, double lng1, double lat2, double lng2) {
  const radiansPerDegree = math.pi / 180;
  final deltaLat = (lat2 - lat1) * radiansPerDegree;
  final deltaLng = (lng2 - lng1) * radiansPerDegree;
  final a =
      math.pow(math.sin(deltaLat / 2), 2) +
      math.cos(lat1 * radiansPerDegree) *
          math.cos(lat2 * radiansPerDegree) *
          math.pow(math.sin(deltaLng / 2), 2);
  return 6371000 * 2 * math.asin(math.sqrt(a.clamp(0, 1)));
}

class AttendanceCheck {
  const AttendanceCheck(this.position, this.distance);

  final AttendancePosition position;
  final double distance;

  static Future<AttendanceCheck> run(
    AttendanceEvent event,
    Future<AttendancePosition> Function() locate, {
    DateTime Function()? now,
  }) async {
    final clock = now ?? DateTime.now;
    event.checkWindow(clock());
    final position = await locate();
    event.checkWindow(clock());
    return AttendanceCheck(position, event.checkLocation(position));
  }
}
