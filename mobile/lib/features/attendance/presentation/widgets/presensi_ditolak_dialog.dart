import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'presensi_dialog.dart';

/// Kartu penolakan presensi untuk pratinjau radius dan lokasi palsu.
class PresensiDitolakDialog extends StatelessWidget {
  const PresensiDitolakDialog({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => PresensiDialog(
    children: [
      Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.errorTint,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.errorBorder),
          ),
          child: const Icon(
            Icons.location_off_rounded,
            color: AppColors.error,
            size: 36,
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.errorText,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: () => Navigator.of(context).pop(),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.refresh_rounded, size: 20),
        label: const Text('Coba Ulang', textAlign: TextAlign.center),
      ),
      const SizedBox(height: 4),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Kembali ke Beranda', textAlign: TextAlign.center),
      ),
      const SizedBox(height: 8),
      const Text(
        'Data contoh · Lokasi belum diperiksa',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
      ),
    ],
  );
}
