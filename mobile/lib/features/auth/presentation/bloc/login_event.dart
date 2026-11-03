import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// Dipanggil ketika pengguna mengetik email.
class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

// Dipanggil ketika pengguna mengetik password.
class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

// Dipanggil ketika pengguna menekan ikon mata.
class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

// Dipanggil ketika checkbox tetap masuk berubah.
class LoginRememberMeToggled extends LoginEvent {
  const LoginRememberMeToggled();
}

// Dipanggil ketika tombol Masuk ditekan.
class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}