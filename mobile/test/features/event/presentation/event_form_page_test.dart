import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/domain/entities/event.dart';
import 'package:absen_kuy/features/event/presentation/pages/event_form_page.dart';

import '../support/fake_event_repository.dart';

const double _minRadiusHint = 30;

void main() {
  Widget wrap({Event? event}) {
    return MaterialApp(
      home: EventFormPage(repository: FakeEventRepository(), event: event),
    );
  }

  /// Perbesar area uji agar seluruh isi form (bagian lokasi & radius) terbangun,
  /// karena ListView hanya membangun widget yang terlihat.
  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('menolak simpan bila judul kosong (M3.5)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan & Jadwalkan Kegiatan'));
    await tester.pump();

    expect(find.text('Judul kegiatan wajib diisi'), findsOneWidget);
  });

  testWidgets('menolak simpan bila jam selesai sebelum jam mulai (M3.5)', (
    WidgetTester tester,
  ) async {
    final DateTime start = DateTime(2026, 10, 24, 10);
    final Event invalid = Event(
      id: '1',
      groupId: '1',
      title: 'Kegiatan',
      location: const EventLocation(point: GeoPoint(-6.97, 107.63)),
      startAt: start,
      endAt: start.subtract(const Duration(hours: 1)),
    );

    await tester.pumpWidget(wrap(event: invalid));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan & Jadwalkan Kegiatan'));
    await tester.pump();

    expect(find.text('Jam selesai harus setelah jam mulai'), findsOneWidget);
  });

  testWidgets('menampilkan radius minimum 30 meter pada slider (M3.5)', (
    WidgetTester tester,
  ) async {
    useTallViewport(tester);
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Radius Presensi: 50 Meter'), findsOneWidget);
    final Slider slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.min, _minRadiusHint);
  });

  testWidgets('menampilkan alamat koordinat bila alamat kosong (M3.6)', (
    WidgetTester tester,
  ) async {
    useTallViewport(tester);
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    // Titik awal tanpa alamat -> tampilkan koordinat.
    expect(find.textContaining('-6.97320'), findsOneWidget);
  });
}
