import 'dart:io';

abstract class SelfieRepository {
  Future<File?> takePhoto();
  Future<File?> recoverPhoto();
  Future<void> deletePhoto(File? photo);
}
