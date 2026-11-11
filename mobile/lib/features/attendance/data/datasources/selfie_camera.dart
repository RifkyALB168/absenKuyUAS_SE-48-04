import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../domain/repositories/selfie_repository.dart';

class SelfieCamera implements SelfieRepository {
  SelfieCamera({
    ImagePicker? picker,
    Future<Directory> Function()? temporaryDirectory,
  }) : _picker = picker ?? ImagePicker(),
       _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  final ImagePicker _picker;
  final Future<Directory> Function() _temporaryDirectory;

  @override
  Future<File?> takePhoto() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 480,
      maxHeight: 480,
      imageQuality: 60,
      requestFullMetadata: false,
    );
    return photo == null ? null : _savePhoto(photo);
  }

  @override
  Future<File?> recoverPhoto() async {
    if (!Platform.isAndroid) return null;
    final response = await _picker.retrieveLostData();
    if (response.exception != null) throw response.exception!;
    final photos = response.files;
    return photos == null || photos.isEmpty ? null : _savePhoto(photos.first);
  }

  Future<File> _savePhoto(XFile photo) async {
    final directory = await _temporaryDirectory();
    final destination = File(
      path.join(
        directory.path,
        'selfie_${DateTime.now().microsecondsSinceEpoch}${path.extension(photo.path)}',
      ),
    );
    try {
      await photo.saveTo(destination.path);
      if (await destination.length() == 0) {
        throw const FileSystemException('File selfie kosong');
      }
      return destination;
    } catch (_) {
      await deletePhoto(destination);
      rethrow;
    }
  }

  @override
  Future<void> deletePhoto(File? photo) async {
    if (photo == null) return;
    try {
      await photo.delete();
    } on FileSystemException {
      // File cache dapat lebih dahulu dibersihkan oleh sistem.
    }
  }
}
