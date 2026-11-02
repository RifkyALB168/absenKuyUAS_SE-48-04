import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../pages/kegiatan.dart';

/// Kartu satu kegiatan pada daftar M3.
///
/// Hanya menampilkan data dari [Kegiatan]; tidak ada aksi selain
/// [onTap] opsional.
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.kegiatan, this.onTap});

  final Kegiatan kegiatan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _Chip(text: kegiatan.kelompok, tinted: true),
                const Spacer(),
                _StatusChip(status: kegiatan.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              kegiatan.judul,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            _MetaRow(
              icon: Icons.event_outlined,
              text: '${kegiatan.tanggal} • ${kegiatan.jam}',
            ),
            const SizedBox(height: 6),
            _MetaRow(
              icon: Icons.place_outlined,
              text: '${kegiatan.lokasi} • Radius ${kegiatan.radiusMeter} m',
            ),
            const Divider(height: 22, color: AppColors.border),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.groups_outlined,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${kegiatan.hadir}/${kegiatan.total} anggota hadir',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Baris ikon + teks untuk tanggal dan lokasi.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Icon(icon, size: 14, color: AppColors.textSecondary),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ),
    ],
  );
}

/// Chip nama kelompok.
class _Chip extends StatelessWidget {
  const _Chip({required this.text, this.tinted = false});

  final String text;
  final bool tinted;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: tinted ? AppColors.primaryTint : AppColors.background,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: tinted ? AppColors.primary : AppColors.textSecondary,
      ),
    ),
  );
}

/// Chip status kegiatan dengan warna sesuai [StatusKegiatan].
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final StatusKegiatan status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color fg, Color bg) = switch (status) {
      StatusKegiatan.berlangsung => (
        'Berlangsung',
        AppColors.success,
        AppColors.successTint,
      ),
      StatusKegiatan.dijadwalkan => (
        'Dijadwalkan',
        AppColors.primary,
        AppColors.primaryTint,
      ),
      StatusKegiatan.ditutup => (
        'Ditutup',
        AppColors.textSecondary,
        AppColors.background,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: fg.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
