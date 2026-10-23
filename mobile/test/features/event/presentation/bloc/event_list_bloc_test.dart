import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/domain/entities/event.dart';
import 'package:absen_kuy/features/event/presentation/bloc/event_list_bloc.dart';
import 'package:absen_kuy/features/event/presentation/bloc/event_list_event.dart';
import 'package:absen_kuy/features/event/presentation/bloc/event_list_state.dart';

import '../../support/fake_event_repository.dart';

Event _event(String id, DateTime start) {
  return Event(
    id: id,
    groupId: '1',
    title: 'Kegiatan $id',
    location: const EventLocation(point: GeoPoint(-6.97, 107.63)),
    startAt: start,
    endAt: start.add(const Duration(hours: 1)),
  );
}

void main() {
  final DateTime base = DateTime(2026, 10, 24, 9);

  group('EventListBloc', () {
    blocTest<EventListBloc, EventListState>(
      'memuat daftar dan mengurutkannya menurut waktu mulai',
      build: () => EventListBloc(
        FakeEventRepository(
          events: <Event>[
            _event('b', base.add(const Duration(hours: 5))),
            _event('a', base),
          ],
        ),
      ),
      act: (EventListBloc bloc) => bloc.add(const EventListLoadRequested()),
      expect: () => <Matcher>[
        isA<EventListState>().having(
          (EventListState s) => s.status,
          'status',
          EventListStatus.loading,
        ),
        isA<EventListState>()
            .having(
              (EventListState s) => s.status,
              'status',
              EventListStatus.success,
            )
            .having(
              (EventListState s) => s.events.map((Event e) => e.id).toList(),
              'urut id',
              <String>['a', 'b'],
            ),
      ],
    );

    blocTest<EventListBloc, EventListState>(
      'menyimpan kegiatan baru lalu memuat ulang',
      build: () => EventListBloc(FakeEventRepository()),
      act: (EventListBloc bloc) => bloc.add(EventAdded(_event('x', base))),
      expect: () => <Matcher>[
        isA<EventListState>()
            .having(
              (EventListState s) => s.status,
              'status',
              EventListStatus.success,
            )
            .having(
              (EventListState s) => s.lastMessage,
              'pesan',
              'Kegiatan disimpan',
            )
            .having((EventListState s) => s.events.length, 'jumlah', 1),
      ],
    );

    blocTest<EventListBloc, EventListState>(
      'menghapus kegiatan',
      build: () => EventListBloc(
        FakeEventRepository(events: <Event>[_event('a', base)]),
      ),
      act: (EventListBloc bloc) => bloc.add(const EventRemoved('a')),
      expect: () => <Matcher>[
        isA<EventListState>()
            .having(
              (EventListState s) => s.lastMessage,
              'pesan',
              'Kegiatan dihapus',
            )
            .having((EventListState s) => s.events, 'kosong', isEmpty),
      ],
    );

    blocTest<EventListBloc, EventListState>(
      'menampilkan state gagal saat pemuatan gagal',
      build: () => EventListBloc(FakeEventRepository(failOnLoad: true)),
      act: (EventListBloc bloc) => bloc.add(const EventListLoadRequested()),
      expect: () => <Matcher>[
        isA<EventListState>().having(
          (EventListState s) => s.status,
          'status',
          EventListStatus.loading,
        ),
        isA<EventListState>()
            .having(
              (EventListState s) => s.status,
              'status',
              EventListStatus.failure,
            )
            .having((EventListState s) => s.errorMessage, 'pesan', isNotNull),
      ],
    );
  });
}
