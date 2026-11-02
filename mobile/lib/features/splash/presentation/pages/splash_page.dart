import 'dart:async';

import 'package:flutter/material.dart';

/// Halaman pembuka yang tampil sesaat ketika aplikasi dibuka.
///
/// Setelah [duration], halaman ini diganti (`pushReplacement`) dengan halaman
/// dari [nextPageBuilder], sehingga tombol back tidak kembali ke Splash.
/// Penentuan halaman tujuan (Login atau Beranda berdasarkan sesi tersimpan, S4)
/// dilakukan oleh pemanggil.
class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.nextPageBuilder,
    this.duration = const Duration(seconds: 2),
    this.waitForFirstFrame = true,
  });

  final WidgetBuilder nextPageBuilder;
  final Duration duration;

  /// Jika `true`, [duration] baru dihitung setelah frame pertama selesai
  /// digambar ke layar. Di Android 12+ layar splash native menutupi aplikasi
  /// sampai saat itu, yang bisa lama (terutama mode debug), sehingga tanpa ini
  /// Splash nyaris tidak terlihat. Set `false` di widget test, karena di sana
  /// frame tidak pernah benar-benar digambar.
  final bool waitForFirstFrame;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.waitForFirstFrame) {
      WidgetsBinding.instance.waitUntilFirstFrameRasterized.then(
        (_) => _startTimer(),
      );
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    if (!mounted) return;
    _timer = Timer(widget.duration, _goToNextPage);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToNextPage() {
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: widget.nextPageBuilder));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    // Latar putih disamakan dengan @color/splash_background di Android
    // (res/values/colors.xml); ikon status bar gelap mengikuti default di app.dart.
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/logo.webp',
                width: _logoSize,
                height: _logoSize,
                // Logo asli 2000 px; cukup didekode seukuran tampilannya.
                cacheWidth: (_logoSize * pixelRatio).round(),
                semanticLabel: 'Logo absenKuy',
              ),
              const SizedBox(height: 16),
              Text(
                'absenKuy',
                style: textTheme.headlineMedium?.copyWith(
                  color: _logoNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Presensi kegiatan UKM & organisasi',
                style: textTheme.bodyMedium?.copyWith(
                  color: _logoNavy.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: _logoOrange,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

const double _logoSize = 160;

// Diambil dari warna logo (assets/images/logo.webp).
const Color _logoNavy = Color(0xFF1C3C78);
const Color _logoOrange = Color(0xFFF36E19);
