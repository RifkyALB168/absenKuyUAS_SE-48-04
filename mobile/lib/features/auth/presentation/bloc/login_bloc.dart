
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

LoginBloc({AuthRepository? repository})
    : authRepository = repository ?? AuthRepository(),
      super(const LoginState()) {
    // Ketika email berubah.
    on<LoginEmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: event.email,
          clearEmailError: true,
          clearLoginError: true,
          status: LoginStatus.initial,
        ),
      );
    });

    // Ketika password berubah.
    on<LoginPasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          clearPasswordError: true,
          clearLoginError: true,
          status: LoginStatus.initial,
        ),
      );
    });

    // Ketika tombol mata password ditekan.
    on<LoginPasswordVisibilityToggled>((event, emit) {
      emit(
        state.copyWith(
          isPasswordVisible: !state.isPasswordVisible,
        ),
      );
    });

    // Ketika checkbox tetap masuk berubah.
    on<LoginRememberMeToggled>((event, emit) {
      emit(
        state.copyWith(
          rememberMe: !state.rememberMe,
        ),
      );
    });

    // Ketika tombol Masuk ditekan.
    on<LoginSubmitted>((event, emit) {
      String? emailError;
      String? passwordError;

      // Validasi email.
      if (state.email.trim().isEmpty) {
        emailError = 'Email tidak boleh kosong';
      } else if (!RegExp(
        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
      ).hasMatch(state.email.trim())) {
        emailError = 'Format email tidak valid';
      }

      // Validasi password.
      if (state.password.isEmpty) {
        passwordError = 'Password tidak boleh kosong';
      } else if (state.password.length < 6) {
        passwordError = 'Password minimal 6 karakter';
      }

      // Jika terdapat kesalahan input.
      if (emailError != null || passwordError != null) {
        emit(
          state.copyWith(
            emailError: emailError,
            passwordError: passwordError,
            clearLoginError: true,
            status: LoginStatus.validationFailure,
          ),
        );
        return;
      }

      // Memeriksa akun di AuthRepository.
      final user = authRepository.login(
        state.email.trim(),
        state.password,
      );

      if (user != null) {
        // Login berhasil.
        emit(
          state.copyWith(
            clearEmailError: true,
            clearPasswordError: true,
            clearLoginError: true,
            status: LoginStatus.authenticated,
          ),
        );
      } else {
        // Email atau password salah.
        emit(
          state.copyWith(
            loginError: 'Email atau password salah!',
            status: LoginStatus.authenticationFailure,
          ),
        );
      }
    });
  }
}
