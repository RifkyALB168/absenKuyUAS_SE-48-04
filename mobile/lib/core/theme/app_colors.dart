import 'package:flutter/material.dart';

/// Token warna absenKuy, diambil dari dokumen desain bagian 1 dan 6.
///
/// Dipakai oleh [AppTheme] dan widget fitur. Jangan menulis nilai hex langsung
/// di halaman; ambil dari sini supaya palet tetap konsisten.
class AppColors {
  AppColors._();

  /// Latar utama (60%), mis. Scaffold dan App Bar.
  static const Color surface = Color(0xFFFFFFFF);

  /// Latar sekunder (30%), mis. latar layar dan isian input.
  static const Color background = Color(0xFFF8FAFC);

  /// Garis tepi kartu dan pemisah.
  static const Color border = Color(0xFFE2E8F0);

  /// Warna brand utama (10%): tombol utama, chip aktif, pin peta.
  static const Color primary = Color(0xFF2563EB);

  /// Tint biru muda untuk chip aktif dan lingkaran radius peta.
  static const Color primaryTint = Color(0xFFEFF6FF);

  /// Teks judul dan nama.
  static const Color textPrimary = Color(0xFF0F172A);

  /// Teks sekunder: waktu, jarak, NIM, helper text.
  static const Color textSecondary = Color(0xFF64748B);

  /// Hadir atau di dalam radius.
  static const Color success = Color(0xFF10B981);

  /// Latar badge status hadir.
  static const Color successTint = Color(0xFFECFDF5);

  /// Izin atau menunggu persetujuan.
  static const Color warning = Color(0xFFF59E0B);

  /// Latar badge status izin.
  static const Color warningTint = Color(0xFFFFFBEB);

  /// Di luar radius atau mock GPS.
  static const Color error = Color(0xFFF43F5E);

  /// Latar badge status ditolak.
  static const Color errorTint = Color(0xFFFFF1F2);
}
