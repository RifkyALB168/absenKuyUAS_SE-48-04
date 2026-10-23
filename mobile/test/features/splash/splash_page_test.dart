import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/features/splash/presentation/pages/splash_page.dart';

void main() {
  const duration = Duration(seconds: 2);

  Widget buildSplash() {
    return MaterialApp(
      home: SplashPage(
        duration: duration,
        waitForFirstFrame: false,
        nextPageBuilder: (_) => const Scaffold(body: Text('Halaman tujuan')),
      ),
    );
  }

  testWidgets('menampilkan nama aplikasi dan indikator loading', (
    tester,
  ) async {
    await tester.pumpWidget(buildSplash());

    expect(find.text('absenKuy'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Habiskan timer agar tidak ada timer yang tertinggal saat test selesai.
    await tester.pump(duration);
    await tester.pumpAndSettle();
  });

  testWidgets('belum pindah halaman sebelum durasi habis', (tester) async {
    await tester.pumpWidget(buildSplash());
    await tester.pump(duration - const Duration(milliseconds: 100));

    expect(find.text('Halaman tujuan'), findsNothing);
    expect(find.text('absenKuy'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  });

  testWidgets('mengganti Splash dengan halaman tujuan setelah durasi habis', (
    tester,
  ) async {
    await tester.pumpWidget(buildSplash());
    await tester.pump(duration);
    await tester.pumpAndSettle();

    expect(find.text('Halaman tujuan'), findsOneWidget);
    expect(find.byType(SplashPage), findsNothing);
  });
}
