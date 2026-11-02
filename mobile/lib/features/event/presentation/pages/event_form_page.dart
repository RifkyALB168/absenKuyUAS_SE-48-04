import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'kegiatan.dart';
import 'geofence_picker_page.dart';

/// Halaman "Buat Kegiatan Baru" (M3).
///
/// Mengikuti desain "Buat Kegiatan": kartu Informasi Kegiatan, kartu Jadwal &
/// Waktu Presensi, lalu tombol Simpan & Jadwalkan. Isian masih readOnly dan
/// nilainya diambil dari [kegiatan.dart]; belum ada penyimpanan,
/// validasi, atau panggilan jaringan.
///
/// Kartu "Titik Lokasi & Radius" membuka pemilih titik & radius geofence
/// ([GeofencePickerPage]), sesuai lingkup M3 "pilih lokasi di peta".
class EventFormPage extends StatelessWidget {
  const EventFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 66,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Buat Kegiatan Baru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Kelola Jadwal & Geofence',
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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: <Widget>[
          const _SectionCard(
            icon: Icons.info_outline,
            title: 'Informasi Kegiatan',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _LabelRow(label: 'Pilih Kelompok / Organisasi', trailing: _AdminBadge()),
                SizedBox(height: 8),
                _DropdownField(value: 'UKM CCI'),
                SizedBox(height: 8),
                _HelperNote(
                  text: 'Hanya kelompok di mana Anda berstatus Pengurus',
                ),
                SizedBox(height: 16),
                _LabelText('Judul Kegiatan'),
                SizedBox(height: 8),
                _FilledField(value: judulKegiatan),
                SizedBox(height: 16),
                _LabelRow(label: 'Deskripsi & Agenda', muted: 'Optional'),
                SizedBox(height: 8),
                _FilledField(value: deskripsiKegiatan, lines: 5),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionCard(
            icon: Icons.schedule,
            title: 'Jadwal & Waktu Presensi',
            subtitle: 'Sinkronisasi server kampus',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SyncNote(),
                SizedBox(height: 16),
                _LabelText('Tanggal Kegiatan'),
                SizedBox(height: 8),
                _DateField(value: tanggalKegiatan),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionCard(
            icon: Icons.place_outlined,
            title: 'Titik Lokasi & Radius',
            subtitle: 'Peta geofence',
            child: _LocationSummary(),
          ),
          const SizedBox(height: 20),
          const _SubmitButton(),
          const SizedBox(height: 14),
          const _FooterNote(),
        ],
      ),
    );
  }
}

/// Kartu berjudul dengan ikon kecil di kiri.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

/// Label isian dengan tanda wajib dan/atau teks kanan.
class _LabelRow extends StatelessWidget {
  const _LabelRow({required this.label, this.trailing, this.muted});

  final String label;
  final Widget? trailing;
  final String? muted;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(
        child: Text.rich(
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: <InlineSpan>[
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
      if (muted != null)
        Text(
          muted!,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ?trailing,
    ],
  );
}

/// Label isian tanpa tanda wajib (mis. teks di dalam daftar).
class _LabelText extends StatelessWidget {
  const _LabelText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      children: const <InlineSpan>[
        TextSpan(text: ' *', style: TextStyle(color: AppColors.error)),
      ],
    ),
  );
}

/// Pil biru "ADMIN MODE".
class _AdminBadge extends StatelessWidget {
  const _AdminBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.primaryTint,
      borderRadius: BorderRadius.circular(100),
    ),
    child: const Text(
      'ADMIN MODE',
      style: TextStyle(
        fontSize: 9,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    ),
  );
}

/// Catatan kecil berikon centang hijau.
class _HelperNote extends StatelessWidget {
  const _HelperNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      const Icon(Icons.check_circle, size: 13, color: AppColors.success),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ),
    ],
  );
}

/// Isian yang tampak seperti dropdown kelompok.
class _DropdownField extends StatelessWidget {
  const _DropdownField({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: <Widget>[
        const Icon(
          Icons.account_balance_outlined,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: AppColors.textSecondary,
        ),
      ],
    ),
  );
}

/// Isian teks yang tampil terisi dan tidak dapat diubah.
class _FilledField extends StatelessWidget {
  const _FilledField({required this.value, this.lines = 1});

  final String value;
  final int lines;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 13,
        height: 1.45,
        color: AppColors.textPrimary,
      ),
    ),
  );
}

/// Isian tanggal dengan ikon kalender di kanan.
class _DateField extends StatelessWidget {
  const _DateField({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Icon(
          Icons.calendar_month_outlined,
          size: 18,
          color: AppColors.primary,
        ),
      ],
    ),
  );
}

/// Kotak biru berisi keterangan sinkronisasi waktu.
class _SyncNote extends StatelessWidget {
  const _SyncNote();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.primaryTint,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
    ),
    padding: const EdgeInsets.all(12),
    child: const Row(
      children: <Widget>[
        Icon(Icons.wifi, size: 16, color: AppColors.primary),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Waktu sinkronisasi otomatis'
            ' dengan server kampus (WIB)',
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Ringkasan lokasi dan radius, dengan tombol menuju pemilih titik & radius.
class _LocationSummary extends StatelessWidget {
  const _LocationSummary();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          const Icon(Icons.place, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              alamatGeocoding,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '$radiusMeter m',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => const GeofencePickerPage(),
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.controlRadius),
            ),
            minimumSize: const Size(0, AppTheme.minTouchTarget),
          ),
          icon: const Icon(Icons.map_outlined, size: 17),
          label: const Text(
            'Pilih Titik & Radius di Peta',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ],
  );
}

/// Tombol utama "Simpan & Jadwalkan Kegiatan".
class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton.icon(
      onPressed: () => Navigator.of(context).maybePop(),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.controlRadius),
        ),
      ),
      icon: const Icon(Icons.event_available_outlined, size: 19),
      label: const Text(
        'Simpan & Jadwalkan Kegiatan',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

/// Catatan kaki di bawah tombol simpan.
class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) => const Row(
    children: <Widget>[
      Icon(Icons.info_outline, size: 13, color: AppColors.primary),
      SizedBox(width: 6),
      Expanded(
        child: Text(
          'Otomatis tersinkronisasi di Beranda anggota UKM CCI',
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ),
    ],
  );
}
