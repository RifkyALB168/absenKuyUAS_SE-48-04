import 'package:flutter/material.dart';

/// Root widget aplikasi. Tema (`core/theme`) dan halaman Splash/Login
/// dipasang di sini pada langkah berikutnya.
class AbsenKuyApp extends StatelessWidget {
  const AbsenKuyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'absenKuy',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('absenKuy')),
      ),
    );
  }
}
