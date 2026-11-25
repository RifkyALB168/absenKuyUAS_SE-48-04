import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import 'kegiatan.dart';
import '../widgets/event_card.dart';
import 'event_form_page.dart';
import 'event_detail_page.dart';

/// Daftar kegiatan (M3).
///
/// Judul halaman mengikuti desain "Kegiatan: Kelola Kegiatan & Aktivitasmu".
/// Kartu membuka detail; tombol Buat Kegiatan membuka form M3.
class EventListPage extends StatelessWidget {
  const EventListPage({super.key, this.attendanceRepository, this.activities});

  final AttendanceRepository? attendanceRepository;
  final List<Kegiatan>? activities;

  @override
  Widget build(BuildContext context) {
    final items = activities ?? daftarKegiatan;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 66,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Kegiatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Kelola Kegiatan & Aktivitasmu',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              onPressed: () => _openForm(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.controlRadius),
                ),
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Buat Kegiatan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _FilterRow(count: items.length),
          const SizedBox(height: 14),
          for (final Kegiatan kegiatan in items) ...<Widget>[
            EventCard(
              kegiatan: kegiatan,
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => EventDetailPage(
                    kegiatan: kegiatan,
                    attendanceRepository: attendanceRepository,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  void _openForm(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const EventFormPage()),
    );
  }
}

/// Chip penyaring daftar. Hanya tampilan; tidak ada penyaringan.
class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final labels = ['Semua ($count)', 'Dijadwalkan', 'Berlangsung', 'Ditutup'];
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int index) => Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: index == 0 ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: index == 0 ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            labels[index],
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: index == 0 ? AppColors.surface : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
