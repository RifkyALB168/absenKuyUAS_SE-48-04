import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../domain/attendance_check.dart';

class AttendanceLocation {
  const AttendanceLocation();

  Future<AttendancePosition> read() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const AttendanceBlocked(AttendanceIssue.gpsDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw const AttendanceBlocked(AttendanceIssue.permissionDeniedForever);
      }
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw const AttendanceBlocked(AttendanceIssue.permissionDenied);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return AttendancePosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        isMocked: position.isMocked,
      );
    } on LocationServiceDisabledException {
      throw const AttendanceBlocked(AttendanceIssue.gpsDisabled);
    } on PermissionDeniedException {
      throw const AttendanceBlocked(AttendanceIssue.permissionDenied);
    } on TimeoutException {
      throw const AttendanceBlocked(AttendanceIssue.locationUnavailable);
    }
  }

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<bool> openAppSettings() => Geolocator.openAppSettings();
}
