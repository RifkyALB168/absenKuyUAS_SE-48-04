import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/domain/entities/event.dart';
import 'package:absen_kuy/features/event/presentation/pages/event_list_page.dart';
import 'package:absen_kuy/features/event/presentation/widgets/event_card.dart';

import '../support/fake_event_repository.dart';

Event _event(String id, String title, DateTime start) {
  return Event(
    id: id,
    groupId: '1',
    title: title,
    location: const EventLocation(
      point: GeoPoint(-6.9732, 107.6304),
      radiusMeters: 50,
      address: 'Gedung TULT',
      placeName: 'Gedung TULT',
    ),
    startAt: start,
    endAt: start.add(const Duration(hours: 2)),
  );
}

void main() {
  final DateTime base = DateTime(2026, 10, 24, 9);

  Widget wrap(FakeEventRepository repository) {
    return MaterialApp(home: EventListPage(repository: repository));
  }

  testWidgets('menampilkan kegiatan dari repositori', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        FakeEventRepository(
          events: <Event>[
            _event('1', 'Rapat Pleno', base),
            _event('2', 'Bakti Sosial', base.add(const Duration(days: 1))),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsNWidgets(2));
    expect(find.text('Rapat Pleno'), findsOneWidget);
    expect(find.text('Bakti Sosial'), findsOneWidget);
    expect(find.text('Buat Kegiatan'), findsOneWidget);
  });

  testWidgets('menampilkan empty state saat tidak ada kegiatan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(FakeEventRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Belum Ada Kegiatan'), findsOneWidget);
    expect(find.byType(EventCard), findsNothing);
  });

  testWidgets('menampilkan tombol coba lagi saat pemuatan gagal', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap(FakeEventRepository(failOnLoad: true)));
    await tester.pumpAndSettle();

    expect(find.text('Coba Lagi'), findsOneWidget);
    expect(find.byType(EventCard), findsNothing);
  });

  testWidgets('membuka detail kegiatan saat kartu diketuk', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        FakeEventRepository(events: <Event>[_event('1', 'Rapat Pleno', base)]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(EventCard));
    await tester.pumpAndSettle();

    expect(find.text('Detail Kegiatan'), findsOneWidget);
    expect(find.text('Gedung TULT'), findsWidgets);
    expect(find.text('50m'), findsOneWidget);
  });
}
