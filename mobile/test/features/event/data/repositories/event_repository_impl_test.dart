import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/data/datasources/event_remote_data_source.dart';
import 'package:absen_kuy/features/event/data/datasources/geocoding_remote_data_source.dart';
import 'package:absen_kuy/features/event/data/models/event_model.dart';
import 'package:absen_kuy/features/event/data/repositories/event_repository_impl.dart';
import 'package:absen_kuy/features/event/domain/entities/event.dart';

class _MockEventRemoteDataSource extends Mock
    implements EventRemoteDataSource {}

class _MockGeocodingRemoteDataSource extends Mock
    implements GeocodingRemoteDataSource {}

void main() {
  late _MockEventRemoteDataSource remote;
  late _MockGeocodingRemoteDataSource geocoding;
  late EventRepositoryImpl repository;

  final EventModel sample = EventModel(
    id: '1',
    groupId: '2',
    title: 'Rapat',
    location: const EventLocation(point: GeoPoint(-6.97, 107.63)),
    startAt: DateTime.utc(2026, 10, 24, 1),
    endAt: DateTime.utc(2026, 10, 24, 3),
  );

  setUp(() {
    remote = _MockEventRemoteDataSource();
    geocoding = _MockGeocodingRemoteDataSource();
    repository = EventRepositoryImpl(
      remoteDataSource: remote,
      geocodingDataSource: geocoding,
    );
  });

  setUpAll(() {
    // mocktail butuh nilai contoh untuk matcher any() bertipe EventModel.
    registerFallbackValue(
      EventModel(
        id: '',
        groupId: '',
        title: '',
        location: const EventLocation(point: GeoPoint(0, 0)),
        startAt: DateTime.fromMillisecondsSinceEpoch(0),
        endAt: DateTime.fromMillisecondsSinceEpoch(0),
      ),
    );
  });

  test(
    'getEvents meneruskan filter groupId dan hasilnya tidak dapat diubah',
    () async {
      when(() => remote.fetchEvents(groupId: '2'))
          .thenAnswer((_) async => [sample]);

      final List<Event> events = await repository.getEvents(groupId: '2');

      expect(events, [sample]);
      expect(() => events.add(sample), throwsUnsupportedError);
      verify(() => remote.fetchEvents(groupId: '2')).called(1);
    },
  );

  test('getEvents tanpa filter mengirim groupId null', () async {
    when(() => remote.fetchEvents()).thenAnswer((_) async => [sample]);

    await repository.getEvents();

    verify(() => remote.fetchEvents(groupId: null)).called(1);
  });

  test('getGroupEvents memakai endpoint kelompok', () async {
    when(() => remote.fetchGroupEvents('2')).thenAnswer((_) async => [sample]);

    final List<Event> events = await repository.getGroupEvents('2');

    expect(events.single.id, '1');
    verify(() => remote.fetchGroupEvents('2')).called(1);
  });

  test('createEvent membungkus entitas menjadi model', () async {
    when(() => remote.createEvent(any())).thenAnswer((_) async => sample);

    final Event created = await repository.createEvent(sample);

    expect(created, sample);
    final EventModel sent =
        verify(() => remote.createEvent(captureAny())).captured.single
            as EventModel;
    expect(sent.groupId, '2');
    expect(sent.title, 'Rapat');
  });

  test('updateEvent mengirim id kegiatan', () async {
    when(() => remote.updateEvent(any())).thenAnswer((_) async => sample);

    await repository.updateEvent(sample);

    final EventModel sent =
        verify(() => remote.updateEvent(captureAny())).captured.single
            as EventModel;
    expect(sent.id, '1');
  });

  test('deleteEvent meneruskan id', () async {
    when(() => remote.deleteEvent('1')).thenAnswer((_) async {});

    await repository.deleteEvent('1');

    verify(() => remote.deleteEvent('1')).called(1);
  });

  test('resolveAddress memakai data source geocoding', () async {
    const GeoPoint point = GeoPoint(-6.97, 107.63);
    when(() => geocoding.reverseGeocode(point))
        .thenAnswer((_) async => 'Bandung');

    expect(await repository.resolveAddress(point), 'Bandung');
    verify(() => geocoding.reverseGeocode(point)).called(1);
  });
}
