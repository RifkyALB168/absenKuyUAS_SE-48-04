import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Banner status jarak terhadap radius kegiatan (M4.3, M9.4).
///
/// M4 dikerjakan PIC lain; widget ini hanya menampilkan hasil perhitungan jarak
/// agar halaman detail kegiatan dapat menunjukkan status geofence.
class GeofenceStatusBanner extends StatelessWidget {
  const GeofenceStatusBanner({
    super.key,
    required this.distanceMeters,
    required this.radiusMeters,
  });

  final double distanceMeters;
  final double radiusMeters;

  @override
  Widget build(BuildContext context) {
    final bool inside = distanceMeters <= radiusMeters;
    final Color background = inside
        ? AppColors.successTint
        : AppColors.errorTint;
    final Color accent = inside ? AppColors.success : AppColors.error;
    final IconData icon = inside
        ? Icons.check_circle_outline
        : Icons.location_off_outlined;

    final String title = inside
        ? 'Di Dalam Area Presensi'
        : 'Di Luar Area Presensi';
    final String detail = inside
        ? 'Jarak Anda: ${distanceMeters.round()}m (Maks. ${radiusMeters.round()}m)'
        : 'Jarak Anda: ${distanceMeters.round()}m (Maks. ${radiusMeters.round()}m)';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(color: accent, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
