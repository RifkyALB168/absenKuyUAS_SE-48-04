import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/attendance_check.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/selfie_repository.dart';
import 'selfie_state.dart';

class SelfieCubit extends Cubit<SelfieState> {
  SelfieCubit(this._camera) : super(const SelfieState());

  final SelfieRepository _camera;
  AttendancePosition? _pendingPosition;
  String? _requestId;

  Future<void> recoverPhoto() => _loadPhoto(_camera.recoverPhoto);

  Future<void> takePhoto() => _loadPhoto(_camera.takePhoto);

  Future<void> _loadPhoto(Future<File?> Function() load) async {
    if (isClosed || state.isBusy || state.retrying || state.submitted) return;
    final previous = state.photo;
    emit(SelfieState(photo: previous, isBusy: true));
    try {
      final photo = await load();
      if (isClosed) {
        await _camera.deletePhoto(photo);
        return;
      }
      emit(SelfieState(photo: photo ?? previous));
      if (photo != null && photo.path != previous?.path) {
        await _camera.deletePhoto(previous);
      }
    } on PlatformException catch (error) {
      if (isClosed) return;
      final message = switch (error.code) {
        'camera_access_denied' || 'camera_access_restricted' => 'Akses kamera ditolak. Izinkan kamera melalui pengaturan aplikasi, lalu coba lagi.',
        'no_available_camera' => 'Kamera tidak tersedia pada perangkat ini.',
        _ => 'Kamera tidak dapat dibuka. Silakan coba lagi.',
      };
      emit(SelfieState(photo: previous, error: message));
    } on FileSystemException {
      if (!isClosed) {
        emit(
          SelfieState(
            photo: previous,
            error: 'Selfie tidak dapat disimpan. Periksa ruang penyimpanan dan coba lagi.',
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          SelfieState(
            photo: previous,
            error: 'Foto gagal diproses. Silakan coba lagi.',
          ),
        );
      }
    }
  }

  Future<void> submit({
    required AttendanceEvent event,
    required Future<AttendancePosition> Function() locate,
    required AttendanceRepository repository,
  }) async {
    final photo = state.photo;
    if (isClosed ||
        state.isBusy ||
        state.submitted ||
        photo == null ||
        event.isDemo) {
      return;
    }

    emit(SelfieState(photo: photo, isBusy: true, isSubmitting: true));
    try {
      // Saat respons putus, ulangi kiriman yang sama untuk memulihkan hasilnya.
      final position =
          _pendingPosition ??
          (await AttendanceCheck.run(event, locate)).position;
      if (isClosed) return;
      final random = Random.secure();
      final requestId = _requestId ??= List.generate(
        16,
        (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
      _pendingPosition = position;
      await repository.submit(
        event: event,
        position: position,
        photo: photo,
        requestId: requestId,
      );
      _pendingPosition = null;
      if (!isClosed) emit(const SelfieState(submitted: true));
      await _camera.deletePhoto(photo);
    } on AttendanceBlocked catch (failure) {
      if (!isClosed) emit(SelfieState(photo: photo, issue: failure));
    } on AttendanceSubmitFailure catch (failure) {
      if (!failure.retrySameRequest) {
        _pendingPosition = null;
        _requestId = null;
      }
      if (!isClosed) {
        emit(
          SelfieState(
            photo: photo,
            error: failure.message,
            retrying: _pendingPosition != null,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          SelfieState(
            photo: photo,
            error: 'Presensi belum bisa dikonfirmasi. Silakan coba lagi.',
            retrying: _pendingPosition != null,
          ),
        );
      }
    }
  }

  @override
  Future<void> close() async {
    final photo = state.photo;
    await super.close();
    await _camera.deletePhoto(photo);
  }
}
