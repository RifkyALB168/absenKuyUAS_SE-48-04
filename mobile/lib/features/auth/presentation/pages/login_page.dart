import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'register_page.dart';
import '../../../home/presentation/pages/main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            }

            if (state.status == LoginStatus.authenticationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.loginError ?? 'Login gagal!')),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24),

                  // Logo aplikasi.
                  Center(
                    child: Image.asset(
                      'assets/images/logo.webp',
                      width: 76,
                      height: 76,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Judul halaman.
                  Text(
                    'Selamat Datang di absenKuy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Masuk untuk melanjutkan ke akun Anda',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 32),

                  // Tab Masuk dan Daftar.
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              'Masuk',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(9),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Daftar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),

                  // Label email.
                  Text(
                    'Email Mahasiswa / Kampus',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Input email.
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      context.read<LoginBloc>().add(LoginEmailChanged(value));
                    },
                    decoration: InputDecoration(
                      hintText: 'nama@email.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                      ),
                      errorText: state.emailError,
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Label password.
                  Text(
                    'Kata Sandi',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Input password.
                  TextField(
                    obscureText: !state.isPasswordVisible,
                    onChanged: (value) {
                      context.read<LoginBloc>().add(
                        LoginPasswordChanged(value),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Masukkan kata sandi',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          context.read<LoginBloc>().add(
                            LoginPasswordVisibilityToggled(),
                          );
                        },
                      ),
                      errorText: state.passwordError,
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Checkbox dan lupa password.
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.read<LoginBloc>().add(
                              LoginRememberMeToggled(),
                            );
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: state.rememberMe,
                                activeColor: AppColors.primary,
                                onChanged: (value) {
                                  context.read<LoginBloc>().add(
                                    LoginRememberMeToggled(),
                                  );
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'Tetap masuk di perangkat ini',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fitur lupa kata sandi belum tersedia.',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Tombol masuk.
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<LoginBloc>().add(LoginSubmitted());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
