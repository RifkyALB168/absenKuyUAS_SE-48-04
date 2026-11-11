import 'dart:io';

import 'package:equatable/equatable.dart';

class SelfieState extends Equatable {
  const SelfieState({this.photo, this.isBusy = false, this.error});

  final File? photo;
  final bool isBusy;
  final String? error;

  @override
  List<Object?> get props => [photo?.path, isBusy, error];
}
