import 'package:absen_kuy/features/attendance/presentation/pages/presensi_selfie_page.dart';
import 'package:absen_kuy/features/home/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pratinjau dibuka dari Kegiatan dan ditutup kembali ke tab itu', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainPage()));
    await tester.tap(find.text('Kegiatan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pratinjau UI Presensi'));
    await tester.pumpAndSettle();

    expect(find.text('Kamera Presensi Selfie'), findsOneWidget);
    expect(find.text('Pratinjau UI · Data contoh'), findsOneWidget);

    await tester.tap(find.byTooltip('Tutup presensi'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiSelfiePage), findsNothing);
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      1,
    );
  });

  testWidgets('tombol kamera menjelaskan pratinjau dan Kirim belum aktif', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PresensiSelfiePage()));
    final shutter = find.byTooltip('Ambil foto contoh');
    await tester.ensureVisible(shutter);
    await tester.tap(shutter);
    await tester.pumpAndSettle();

    expect(find.text('Pratinjau UI: kamera belum diaktifkan.'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets('layar kecil dan teks besar tetap dapat digulir tanpa overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.6)),
          child: child!,
        ),
        home: const PresensiSelfiePage(),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Kirim Presensi Sekarang'));
    await tester.pumpAndSettle();
    expect(find.text('Kirim Presensi Sekarang').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
