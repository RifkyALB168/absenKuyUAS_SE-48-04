
import 'package:equatable/equatable.dart';

enum LoginStatus {
  initial,
  validationFailure,
  validationSuccess,
  authenticationFailure,
  authenticated,
}

class LoginState extends Equatable {
  final String email;
  final String password;

  final bool isPasswordVisible;
  final bool rememberMe;

  final String? emailError;
  final String? passwordError;
  final String? loginError;

  final LoginStatus status;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.emailError,
    this.passwordError,
    this.loginError,
    this.status = LoginStatus.initial,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    String? emailError,
    String? passwordError,
    String? loginError,
    LoginStatus? status,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearLoginError = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible:
          isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError:
          clearEmailError ? null : emailError ?? this.emailError,
      passwordError:
          clearPasswordError ? null : passwordError ?? this.passwordError,
      loginError:
          clearLoginError ? null : loginError ?? this.loginError,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isPasswordVisible,
        rememberMe,
        emailError,
        passwordError,
        loginError,
        status,
      ];
}
