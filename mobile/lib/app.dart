import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/splash/presentation/pages/splash_page.dart';

class AbsenKuyApp extends StatelessWidget {
  const AbsenKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'absenKuy',
      debugShowCheckedModeBanner: false,
      // Sementara sampai tema dari core/theme (mengikuti Figma) tersedia.
      // primary sama dengan @color/splash_background di Android (res/values/colors.xml).
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
        ),
      ),
      // Ikon status bar gelap sebagai default; halaman berlatar gelap (Splash)
      // menimpanya dengan AnnotatedRegion sendiri.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: child!,
      ),
      home: SplashPage(
        // Diganti ke Beranda (BottomNavigationBar) pada langkah berikutnya.
        nextPageBuilder: (_) =>
            const Scaffold(body: Center(child: Text('Beranda'))),
      ),
    );
  }
}
