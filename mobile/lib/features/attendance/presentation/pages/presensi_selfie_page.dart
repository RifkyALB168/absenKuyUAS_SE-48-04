import 'package:flutter/material.dart';

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
                  'Posisikan wajah di dalam oval dan pastikan pencahayaan cukup. '
                  'Halaman ini masih pratinjau UI dengan data contoh. '
                  'Kamera, GPS, dan pengiriman presensi belum diaktifkan.',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Rapat Pleno & Evaluasi Mingguan · UKM CCI',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Pratinjau UI · Data contoh',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ),
                  const _CameraPreview(),
                  const SizedBox(height: 12),
                  const _ValidationCard(),
                  const SizedBox(height: 12),
                  const _PhotoControls(),
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
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ColoredBox(
              color: const Color(0xFF25313D),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.67,
                    heightFactor: 0.72,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(color: _guide, width: 1.5),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 88,
                            color: Color(0xFFAAB9C4),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Pratinjau kamera',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFF17212D),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Posisikan wajah Anda tepat di dalam oval',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ColoredBox(
            color: Color(0xFF17212D),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  _PhotoDetail(
                    icon: Icons.location_on_outlined,
                    text: 'Gedung Tokong Nanas (TULT), Lt. 3',
                    color: _guide,
                  ),
                  SizedBox(height: 5),
                  _PhotoDetail(
                    icon: Icons.straighten_rounded,
                    text: 'Jarak: 18 m / Maks: 50 m · Akurasi GPS: ±4 m',
                    color: Color(0xFFA5B4FC),
                  ),
                  SizedBox(height: 5),
                  _PhotoDetail(
                    icon: Icons.schedule_rounded,
                    text: '24 Okt 2026 · 15:38:22 WIB (Waktu Server)',
                    color: Color(0xFFFDE68A),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoDetail extends StatelessWidget {
  const _PhotoDetail({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            height: 1.4,
          ),
        ),
      ),
    ],
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
            children: [
              Expanded(
                child: _ValidationItem(
                  icon: Icons.verified_outlined,
                  title: 'Geofence',
                  subtitle: '18 m / 50 m (Valid)',
                ),
              ),
              SizedBox(width: 8),
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
      children: [
        Icon(icon, size: 18, color: _green),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _green,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
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
                tooltip: 'Ambil foto contoh',
                style: IconButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pratinjau UI: kamera belum diaktifkan.'),
                  ),
                ),
                icon: const Icon(Icons.photo_camera_outlined, size: 28),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: null,
          child: const Text('Kirim Presensi Sekarang'),
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
const _guide = Color(0xFF8BD5AF);
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: const Color(0xFFE0E3E5)),
);
