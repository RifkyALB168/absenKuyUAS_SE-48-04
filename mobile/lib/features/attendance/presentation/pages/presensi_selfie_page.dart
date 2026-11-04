import 'package:flutter/material.dart';

import '../widgets/presensi_berhasil_dialog.dart';
import '../widgets/presensi_di_luar_radius_dialog.dart';
import '../widgets/presensi_fake_gps_dialog.dart';

/// Pratinjau UI M4 dengan data contoh; belum mengakses kamera, GPS, atau API.
class PresensiSelfiePage extends StatelessWidget {
  const PresensiSelfiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Tutup presensi',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Kamera Presensi Selfie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Bantuan presensi',
            icon: const Icon(Icons.help_outline_rounded, size: 22),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Panduan foto selfie'),
                content: const Text(
                  'Posisikan wajah di tengah kamera dan pastikan pencahayaan cukup.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Mengerti'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  _CameraPreview(),
                  _ValidationCard(),
                  _PhotoControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Pratinjau kamera',
    child: AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFF25313D),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFF17212D),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: const Text(
            'Posisikan wajah Anda di tengah kamera',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ),
    ),
  );
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATUS VALIDASI KEAMANAN SISTEM',
            style: TextStyle(color: _muted, fontSize: 10, letterSpacing: 0.4),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: _ValidationItem(
                  icon: Icons.verified_outlined,
                  title: 'Geofence',
                  subtitle: '18 m / 50 m (Valid)',
                ),
              ),
              Expanded(
                child: _ValidationItem(
                  icon: Icons.schedule_rounded,
                  title: 'Waktu NTP',
                  subtitle: 'Tersinkronisasi',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValidationItem extends StatelessWidget {
  const _ValidationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFECFDF5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      spacing: 4,
      children: [
        Icon(icon, size: 18, color: _green),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _green,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _green, fontSize: 10),
        ),
      ],
    ),
  );
}

class _PhotoControls extends StatelessWidget {
  const _PhotoControls();

  Future<void> _previewRejection(BuildContext context, Widget dialog) async {
    final kembaliKeBeranda = await showDialog<bool>(
      context: context,
      builder: (_) => dialog,
    );
    if (kembaliKeBeranda == true && context.mounted) {
      // Pratinjau dibuka dari Beranda; tutup halaman selfie untuk kembali.
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                children: [
                  IconButton(
                    tooltip: 'Foto ulang',
                    onPressed: null,
                    icon: Icon(Icons.restart_alt_rounded),
                  ),
                  Text(
                    'Foto Ulang',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC7D2FE), width: 2),
              ),
              child: IconButton.filled(
                tooltip: 'Ambil foto',
                style: IconButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {},
                icon: const Icon(Icons.photo_camera_outlined, size: 28),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => const PresensiBerhasilDialog(),
          ),
          child: const Text('Kirim Presensi Sekarang'),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () =>
              _previewRejection(context, const PresensiDiLuarRadiusDialog()),
          icon: const Icon(Icons.location_off_outlined, size: 18),
          label: const Text(
            'Simulasi di luar radius',
            textAlign: TextAlign.center,
          ),
        ),
        TextButton.icon(
          onPressed: () =>
              _previewRejection(context, const PresensiFakeGpsDialog()),
          icon: const Icon(Icons.gps_off_rounded, size: 18),
          label: const Text('Simulasi Fake GPS', textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}

const _background = Color(0xFFF7F9FB);
const _ink = Color(0xFF17212D);
const _muted = Color(0xFF596574);
const _blue = Color(0xFF365CE6);
const _green = Color(0xFF24664E);
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: const Color(0xFFE0E3E5)),
);
