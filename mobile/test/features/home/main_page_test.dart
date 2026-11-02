import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/features/home/presentation/pages/main_page.dart';
import 'package:absen_kuy/features/event/presentation/pages/event_list_page.dart';
import 'package:absen_kuy/features/history/presentation/pages/attendance_history_page.dart';

void main() {
  Widget buildMain() => const MaterialApp(home: MainPage());

  int currentIndex(WidgetTester tester) => tester
      .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
      .currentIndex;

  testWidgets('menampilkan 4 tab sesuai Figma dan dibuka di Beranda', (
    tester,
  ) async {
    await tester.pumpWidget(buildMain());

    final nav = find.byType(BottomNavigationBar);
    expect(
      tester.widget<BottomNavigationBar>(nav).items.map((item) => item.label),
      ['Beranda', 'Kegiatan', 'Riwayat', 'Profil'],
    );
    for (final label in ['Beranda', 'Kegiatan', 'Riwayat', 'Profil']) {
      expect(
        find.descendant(of: nav, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(currentIndex(tester), 0);
  });

  testWidgets('menekan tab memindahkan halaman yang tampil', (tester) async {
    await tester.pumpWidget(buildMain());

    final nav = find.byType(BottomNavigationBar);
    const labels = ['Beranda', 'Kegiatan', 'Riwayat', 'Profil'];
    for (final index in [1, 2, 3]) {
      await tester.tap(
        find.descendant(of: nav, matching: find.text(labels[index])),
      );
      await tester.pumpAndSettle();

      expect(currentIndex(tester), index);
      // Riwayat dan Kegiatan sekarang memakai halaman asli, bukan placeholder.
      final page = switch (index) {
        1 => find.byType(EventListPage),
        2 => find.byType(AttendanceHistoryPage),
        _ => find.text('Profil'),
      };
      expect(
        find
            .descendant(of: find.byType(IndexedStack), matching: page)
            .hitTestable(),
        findsOneWidget,
      );
    }
    expect(
      find
          .descendant(
            of: find.byType(IndexedStack),
            matching: find.text('Beranda'),
          )
          .hitTestable(),
      findsNothing,
    );
  });

  testWidgets('tombol back di tab lain kembali ke Beranda dulu', (
    tester,
  ) async {
    await tester.pumpWidget(buildMain());

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();
    expect(currentIndex(tester), 2);

    final handled = await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(handled, isTrue);
    expect(currentIndex(tester), 0);
  });
}
