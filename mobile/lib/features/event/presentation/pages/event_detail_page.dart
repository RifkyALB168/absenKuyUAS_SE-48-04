import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../event_formatters.dart';
import '../widgets/geofence_map_preview.dart';
import '../widgets/geofence_status_banner.dart';
import 'event_form_page.dart';

/// Hasil kembali dari halaman detail: kegiatan diubah atau dihapus.
class EventDetailResult {
  const EventDetailResult({this.updated, this.deleted = false});

  /// Kegiatan hasil perubahan, bila pengguna menyimpan perubahan.
  final Event? updated;

  /// True bila pengguna menghapus kegiatan.
  final bool deleted;
}

/// Detail kegiatan (M3.3) dengan peta lokasi & radius (M5.1).
class EventDetailPage extends StatelessWidget {
  const EventDetailPage({
    super.key,
    required this.event,
    required this.repository,
    this.now,
  });

  final Event event;
  final EventRepository repository;

  /// Waktu acuan status kegiatan; diisi pada pengujian.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final DateTime reference = now ?? DateTime.now();

    // Lokasi contoh supaya status geofence terlihat. GPS asli berasal dari M4
    // (geolocator); M5.2/M5.3 memakai titik presensi anggota dari rekap.
    final GeoPoint sampleLocation = event.location.point.offsetBy(12, 8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kegiatan'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Ubah kegiatan',
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus kegiatan',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.gap),
        children: <Widget>[
          GeofenceMapPreview(
            center: event.location.point,
            radiusMeters: event.location.radiusMeters,
            currentLocation: sampleLocation,
          ),
          const SizedBox(height: 12),
          GeofenceStatusBanner(
            distanceMeters: event.location.point.distanceTo(sampleLocation),
            radiusMeters: event.location.radiusMeters,
          ),
          const SizedBox(height: 12),
          _InfoCard(event: event, now: reference),
          const SizedBox(height: 12),
          const Text(
            'Jarak memakai lokasi contoh. GPS asli dan alur presensi dikerjakan '
            'pada M4; sebaran titik presensi anggota (M5.2) menyusul.',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppTheme.gap),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: AppTheme.minTouchTarget,
              child: FilledButton.icon(
                onPressed: () => _showPending(context, 'Alur presensi (M4)'),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Hadir (Ambil Foto Selfie)'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: AppTheme.minTouchTarget,
              child: OutlinedButton(
                onPressed: () => _showPending(context, 'Pengajuan izin (S1)'),
                child: const Text('Ajukan Izin / Sakit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final Event? updated = await Navigator.of(context).push<Event>(
      MaterialPageRoute<Event>(
        builder: (_) => EventFormPage(repository: repository, event: event),
      ),
    );
    if (updated == null || !context.mounted) return;
    Navigator.of(context).pop(EventDetailResult(updated: updated));
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text(
          '"${event.title}" akan dihapus dan tidak dapat dibatalkan.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pop(const EventDetailResult(deleted: true));
  }

  void _showPending(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia (PIC lain).')),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.event, required this.now});

  final Event event;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final bool ongoing = event.isOpenAt(now);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppTheme.gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  event.location.placeName ?? 'Kegiatan',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ongoing
                      ? AppColors.successTint
                      : AppColors.warningTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  ongoing ? 'Berlangsung' : 'Terjadwal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ongoing ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (event.description.isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              event.description,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 16),
          _Row(
            label: 'Jadwal',
            value: formatSchedule(event.startAt, event.endAt),
          ),
          _Row(
            label: 'Radius',
            value: formatMeters(event.location.radiusMeters),
          ),
          _Row(
            label: 'Alamat',
            value: event.location.address ?? 'Belum ada alamat',
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
