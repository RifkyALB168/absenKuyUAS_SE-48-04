import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/attendance_check.dart';

class SelfieState extends Equatable {
  const SelfieState({
    this.photo,
    this.isBusy = false,
    this.error,
    this.issue,
    this.isSubmitting = false,
    this.retrying = false,
    this.submitted = false,
  });

  final File? photo;
  final bool isBusy;
  final String? error;
  final AttendanceBlocked? issue;
  final bool isSubmitting;
  final bool retrying;
  final bool submitted;

  @override
  List<Object?> get props => [
    photo?.path,
    isBusy,
    error,
    issue,
    isSubmitting,
    retrying,
    submitted,
  ];
}
