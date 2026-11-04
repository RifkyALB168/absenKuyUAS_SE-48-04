import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'presensi_ditolak_dialog.dart';

/// Pratinjau penolakan M4.3 dengan jarak, radius, dan waktu contoh.
class PresensiDiLuarRadiusDialog extends StatelessWidget {
  const PresensiDiLuarRadiusDialog({super.key});

  @override
  Widget build(BuildContext context) => const PresensiDitolakDialog(
    title: 'Lokasi Di Luar Radius',
    subtitle: 'Presensi ditolak karena lokasi di luar jangkauan',
    code: 'OUT_OF_RANGE',
    description: 'Lokasi presensi berada di luar radius kegiatan.',
    details: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DistanceValue(label: 'Jarak Anda', value: '120 m'),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _DistanceValue(label: 'Batas radius', value: '50 m'),
        ),
      ],
    ),
  );
}

class _DistanceValue extends StatelessWidget {
  const _DistanceValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: AppColors.errorText, fontSize: 11),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: AppColors.errorText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
