import 'package:absen_kuy/features/attendance/presentation/pages/presensi_selfie_page.dart';
import 'package:absen_kuy/features/attendance/presentation/widgets/presensi_di_luar_radius_dialog.dart';
import 'package:absen_kuy/features/home/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> bukaErrorRadius(WidgetTester tester) async {
  final tombol = find.text('Simulasi di luar radius');
  await tester.ensureVisible(tombol);
  await tester.tap(tombol);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'penolakan menjelaskan jarak dan radius, lalu bisa dicoba ulang',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: PresensiSelfiePage()));
      await bukaErrorRadius(tester);

      expect(find.text('OUT_OF_RANGE'), findsOneWidget);
      expect(find.text('Jarak Anda'), findsOneWidget);
      expect(find.text('120 m'), findsOneWidget);
      expect(find.text('Batas radius'), findsOneWidget);
      expect(find.text('50 m'), findsOneWidget);
      expect(find.text('Data contoh · Lokasi belum diperiksa'), findsOneWidget);

      await tester.tap(find.text('Coba Ulang'));
      await tester.pumpAndSettle();
      expect(find.byType(PresensiDiLuarRadiusDialog), findsNothing);
      expect(find.byType(PresensiSelfiePage), findsOneWidget);
      await bukaErrorRadius(tester);
      expect(find.byType(PresensiDiLuarRadiusDialog), findsOneWidget);
    },
  );

  testWidgets('Kembali ke Beranda menutup dialog dan halaman selfie', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MainPage()));
    await tester.tap(find.text('Pratinjau UI Presensi'));
    await tester.pumpAndSettle();
    await bukaErrorRadius(tester);
    await tester.ensureVisible(find.text('Kembali ke Beranda'));
    await tester.tap(find.text('Kembali ke Beranda'));
    await tester.pumpAndSettle();

    expect(find.byType(PresensiDiLuarRadiusDialog), findsNothing);
    expect(find.byType(PresensiSelfiePage), findsNothing);
    expect(find.byType(MainPage), findsOneWidget);
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      0,
    );
  });

  testWidgets('dialog tetap dapat dipakai pada layar kecil dengan teks besar', (
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
    await bukaErrorRadius(tester);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Coba Ulang'));
    await tester.tap(find.text('Coba Ulang'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiDiLuarRadiusDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
