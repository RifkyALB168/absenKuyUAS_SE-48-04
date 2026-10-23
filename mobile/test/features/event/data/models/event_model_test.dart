import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/data/models/event_model.dart';
import 'package:absen_kuy/features/event/domain/entities/event.dart';

void main() {
  group('EventModel.fromJson', () {
    test('membaca payload lengkap', () {
      final EventModel event = EventModel.fromJson(const {
        'id': 7,
        'group_id': 3,
        'title': 'Rapat Mingguan',
        'description': 'Rapat rutin pengurus',
        'location': {
          'latitude': -6.9732,
          'longitude': 107.6304,
          'radius_meters': 150,
          'address': 'Jl. Telekomunikasi No.1, Bandung',
          'place_name': 'Gedung TULT',
        },
        'start_at': '2026-10-24T09:00:00.000Z',
        'end_at': '2026-10-24T11:00:00.000Z',
        'status': 'published',
        'created_by': 12,
        'created_at': '2026-10-20T08:00:00.000Z',
      });

      expect(event.id, '7');
      expect(event.groupId, '3');
      expect(event.title, 'Rapat Mingguan');
      expect(event.location.point, const GeoPoint(-6.9732, 107.6304));
      expect(event.location.radiusMeters, 150);
      expect(event.location.address, 'Jl. Telekomunikasi No.1, Bandung');
      expect(event.location.placeName, 'Gedung TULT');
      expect(event.startAt, DateTime.parse('2026-10-24T09:00:00.000Z'));
      expect(event.endAt, DateTime.parse('2026-10-24T11:00:00.000Z'));
      expect(event.status, EventStatus.published);
      expect(event.createdBy, '12');
      expect(event.duration, const Duration(hours: 2));
    });

    test('lokasi hilang memakai radius default dan status draft', () {
      final EventModel event = EventModel.fromJson(const {'id': '1'});

      expect(event.location.point, const GeoPoint(0, 0));
      expect(event.location.radiusMeters, EventLocation.defaultRadiusMeters);
      expect(event.status, EventStatus.draft);
      expect(event.createdAt, isNull);
    });

    test('status tidak dikenal jatuh ke draft', () {
      final EventModel event = EventModel.fromJson(const {
        'id': '1',
        'status': 'whatever',
      });

      expect(event.status, EventStatus.draft);
    });
  });

  group('EventModel.toJson', () {
    test('hanya mengirim field yang diterima backend', () {
      final EventModel event = EventModel(
        id: '9',
        groupId: '2',
        title: 'Kerja Bakti',
        location: const EventLocation(
          point: GeoPoint(-6.97, 107.63),
          radiusMeters: 80,
          address: 'Bandung',
        ),
        startAt: DateTime.utc(2026, 10, 24, 1),
        endAt: DateTime.utc(2026, 10, 24, 3),
        status: EventStatus.published,
      );

      final Map<String, dynamic> json = event.toJson();

      expect(
        json.keys,
        containsAll([
          'title',
          'description',
          'location',
          'start_at',
          'end_at',
          'status',
        ]),
      );
      expect((json['location'] as Map)['radius_meters'], 80);
      expect(json['start_at'], '2026-10-24T01:00:00.000Z');
      expect(json['status'], 'published');
      expect(json.containsKey('id'), isFalse);
    });
  });

  group('EventModel.fromEntity', () {
    test('menyalin seluruh field entitas', () {
      final Event event = Event(
        id: '9',
        groupId: '2',
        title: 'Kerja Bakti',
        location: const EventLocation(point: GeoPoint(-6.97, 107.63)),
        startAt: DateTime.utc(2026, 10, 24, 1),
        endAt: DateTime.utc(2026, 10, 24, 3),
      );

      final EventModel model = EventModel.fromEntity(event);

      // EventModel extends Event, jadi Equatable membandingkan runtimeType
      // juga; bandingkan propertinya agar perbedaan tipe ini diabaikan.
      expect(model.props, event.props);
      expect(model.location.radiusMeters, EventLocation.defaultRadiusMeters);
    });
  });
}
