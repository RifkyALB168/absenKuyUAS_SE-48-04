import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'presensi_dialog.dart';

/// Kartu penolakan beserta tindakan untuk mengatasi masalah presensi.
class PresensiDitolakDialog extends StatelessWidget {
  const PresensiDitolakDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.settings,
  });

  final String title;
  final String subtitle;
  final Future<bool> Function()? settings;

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
        onPressed: settings == null
            ? () => Navigator.of(context).pop()
            : () async {
                var opened = false;
                try {
                  opened = await settings!();
                } catch (_) {
                  // Perangkat dapat meminta pengguna membuka pengaturan sendiri.
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
                if (!opened) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Buka pengaturan dari perangkat Anda.'),
                    ),
                  );
                }
              },
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          settings == null ? Icons.refresh_rounded : Icons.settings_outlined,
          size: 20,
        ),
        label: Text(
          settings == null ? 'Mengerti' : 'Buka Pengaturan',
          textAlign: TextAlign.center,
        ),
      ),
      if (settings != null)
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
    ],
  );
}
