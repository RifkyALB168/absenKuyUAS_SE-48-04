
import 'package:absen_kuy/features/auth/data/models/user_model.dart';

class AuthRepository {
  // List akun digunakan bersama oleh Register dan Login
  static final List<UserModel> _users = [];

  // Mendaftarkan akun baru
  bool register(UserModel user) {
    final emailExists = _users.any(
      (existingUser) =>
          existingUser.email.toLowerCase() ==
          user.email.toLowerCase(),
    );

    if (emailExists) {
      return false;
    }

    _users.add(user);
    return true;
  }

  // Memeriksa akun saat login
  UserModel? login(String email, String password) {
    for (final user in _users) {
      if (user.email.toLowerCase() == email.toLowerCase() &&
          user.password == password) {
        return user;
      }
    }

    return null;
  }

  // Mengambil semua akun
  List<UserModel> get users => List.unmodifiable(_users);
}