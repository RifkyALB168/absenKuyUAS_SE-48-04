import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.where_to_vote_rounded,
                    size: 56,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'absenKuy',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Presensi kegiatan UKM & organisasi',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
