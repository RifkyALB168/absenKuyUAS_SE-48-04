import 'package:absen_kuy/features/attendance/presentation/pages/presensi_selfie_page.dart';
import 'package:absen_kuy/features/attendance/presentation/widgets/presensi_berhasil_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tombol tutup kembali ke halaman sebelumnya', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const PresensiSelfiePage(),
              ),
            ),
            child: const Text('Buka presensi'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka presensi'));
    await tester.pumpAndSettle();
    expect(find.text('Kamera Presensi Selfie'), findsOneWidget);

    await tester.tap(find.byTooltip('Tutup presensi'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiSelfiePage), findsNothing);
    expect(find.text('Buka presensi'), findsOneWidget);
  });

  testWidgets('kirim presensi membuka dialog hasil dan dapat ditutup', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PresensiSelfiePage()));

    await tester.ensureVisible(find.text('Kirim Presensi Sekarang'));
    await tester.tap(find.text('Kirim Presensi Sekarang'));
    await tester.pumpAndSettle();

    expect(find.byType(PresensiBerhasilDialog), findsOneWidget);
    expect(find.text('Presensi Berhasil!'), findsOneWidget);
    expect(find.text('24 Okt 2026, 15:40:12 WIB'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiBerhasilDialog), findsNothing);
    expect(find.byType(PresensiSelfiePage), findsOneWidget);
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
    await tester.tap(find.text('Kirim Presensi Sekarang'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Tutup'));
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(PresensiBerhasilDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
