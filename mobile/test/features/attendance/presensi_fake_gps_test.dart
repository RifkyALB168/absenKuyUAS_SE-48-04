import 'package:absen_kuy/features/attendance/presentation/pages/presensi_selfie_page.dart';
import 'package:absen_kuy/features/attendance/presentation/widgets/presensi_fake_gps_dialog.dart';
import 'package:absen_kuy/features/home/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> bukaErrorFakeGps(WidgetTester tester) async {
  final tombol = find.text('Simulasi Fake GPS');
  await tester.ensureVisible(tombol);
  await tester.tap(tombol);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Fake GPS menampilkan alasan dan dapat dicoba ulang', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PresensiSelfiePage()));
    await bukaErrorFakeGps(tester);

    expect(find.text('Lokasi Palsu Terdeteksi'), findsOneWidget);
    expect(find.text('MOCKED_LOCATION'), findsOneWidget);
    expect(find.textContaining('Nonaktifkan lokasi tiruan'), findsOneWidget);
    expect(find.text('Data contoh · Lokasi belum diperiksa'), findsOneWidget);
    expect(find.text('OUT_OF_RANGE'), findsNothing);
    expect(find.text('120 m'), findsNothing);

    await tester.ensureVisible(find.text('Coba Ulang'));
    await tester.tap(find.text('Coba Ulang'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiFakeGpsDialog), findsNothing);
    expect(find.byType(PresensiSelfiePage), findsOneWidget);
    await bukaErrorFakeGps(tester);
    expect(find.byType(PresensiFakeGpsDialog), findsOneWidget);
  });

  testWidgets('Fake GPS dapat kembali ke Beranda', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainPage()));
    await tester.tap(find.text('Pratinjau UI Presensi'));
    await tester.pumpAndSettle();
    await bukaErrorFakeGps(tester);
    await tester.ensureVisible(find.text('Kembali ke Beranda'));
    await tester.tap(find.text('Kembali ke Beranda'));
    await tester.pumpAndSettle();

    expect(find.byType(PresensiFakeGpsDialog), findsNothing);
    expect(find.byType(PresensiSelfiePage), findsNothing);
    expect(find.byType(MainPage), findsOneWidget);
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      0,
    );
  });

  testWidgets('Fake GPS bisa digulir pada layar kecil dengan teks besar', (
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
    await bukaErrorFakeGps(tester);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Coba Ulang'));
    await tester.tap(find.text('Coba Ulang'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiFakeGpsDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
