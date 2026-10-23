import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tema terang absenKuy ("Clean Campus Emerald & Cobalt").
///
/// Pemetaan design token mengikuti dokumen desain bagian 6. Tema ini
/// menggantikan ThemeData sementara yang sebelumnya ditulis langsung di
/// `app.dart`.
class AppTheme {
  AppTheme._();

  /// Radius sudut kartu kegiatan.
  static const double cardRadius = 16;

  /// Radius sudut tombol dan isian input.
  static const double controlRadius = 12;

  /// Tinggi minimum area ketuk (standar Android).
  static const double minTouchTarget = 48;

  /// Jarak antar elemen mengikuti 8-point grid.
  static const double gap = 16;

  static ThemeData get light {
    final ColorScheme scheme =
        ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.surface,
          secondary: AppColors.success,
          onSecondary: AppColors.surface,
          error: AppColors.error,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.border,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
