import 'dart:io';

import '../attendance_check.dart';

abstract class AttendanceRepository {
  Future<void> submit({
    required AttendanceEvent event,
    required AttendancePosition position,
    required File photo,
    required String requestId,
  });
}

class AttendanceSubmitFailure implements Exception {
  const AttendanceSubmitFailure(this.message, {this.retrySameRequest = false});

  final String message;
  final bool retrySameRequest;
}
