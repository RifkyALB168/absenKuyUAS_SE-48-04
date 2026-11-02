import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/home/presentation/pages/main_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'core/theme/app_theme.dart';

class AbsenKuyApp extends StatelessWidget {
  const AbsenKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'absenKuy',
      debugShowCheckedModeBanner: false,
      // Tema dari core/theme (mengikuti dokumen desain bagian 6).
      // Primary sama dengan @color/splash_background di Android (res/values/colors.xml).
      theme: AppTheme.light,
      // Ikon status bar gelap sebagai default; halaman berlatar gelap (Splash)
      // menimpanya dengan AnnotatedRegion sendiri.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: child!,
      ),
      home: SplashPage(
        // Sementara langsung ke halaman utama; nanti lewat Login/cek sesi (M1, S4).
        nextPageBuilder: (_) => const MainPage(),
      ),
    );
  }
}
