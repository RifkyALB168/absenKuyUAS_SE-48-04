import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/selfie_repository.dart';
import 'selfie_state.dart';

class SelfieCubit extends Cubit<SelfieState> {
  SelfieCubit(this._camera) : super(const SelfieState());

  final SelfieRepository _camera;

  Future<void> recoverPhoto() => _loadPhoto(_camera.recoverPhoto);

  Future<void> takePhoto() => _loadPhoto(_camera.takePhoto);

  Future<void> _loadPhoto(Future<File?> Function() load) async {
    if (isClosed || state.isBusy) return;
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

  @override
  Future<void> close() async {
    final photo = state.photo;
    await super.close();
    await _camera.deletePhoto(photo);
  }
}
