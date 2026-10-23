import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import 'event_list_event.dart';
import 'event_list_state.dart';

/// Mengelola daftar kegiatan: muat, tambah, ubah, hapus (M3).
///
/// Setiap aksi tulis diikuti pemuatan ulang daftar, sehingga urutan dan isi
/// daftar selalu berasal dari sumber data.
class EventListBloc extends Bloc<EventListEvent, EventListState> {
  EventListBloc(this._repository) : super(const EventListState()) {
    on<EventListLoadRequested>(_onLoadRequested);
    on<EventAdded>(_onAdded);
    on<EventChanged>(_onChanged);
    on<EventRemoved>(_onRemoved);
  }

  final EventRepository _repository;

  Future<void> _onLoadRequested(
    EventListLoadRequested event,
    Emitter<EventListState> emit,
  ) async {
    emit(state.copyWith(status: EventListStatus.loading));
    try {
      final List<Event> events = await _repository.getEvents(
        groupId: event.groupId,
      );
      emit(
        EventListState(
          status: EventListStatus.success,
          events: _sorted(events),
        ),
      );
    } catch (error) {
      emit(
        EventListState(status: EventListStatus.failure, errorMessage: '$error'),
      );
    }
  }

  Future<void> _onAdded(EventAdded event, Emitter<EventListState> emit) async {
    await _write(
      () => _repository.createEvent(event.event),
      'Kegiatan disimpan',
      emit,
    );
  }

  Future<void> _onChanged(
    EventChanged event,
    Emitter<EventListState> emit,
  ) async {
    await _write(
      () => _repository.updateEvent(event.event),
      'Perubahan kegiatan disimpan',
      emit,
    );
  }

  Future<void> _onRemoved(
    EventRemoved event,
    Emitter<EventListState> emit,
  ) async {
    await _write(
      () => _repository.deleteEvent(event.id),
      'Kegiatan dihapus',
      emit,
    );
  }

  Future<void> _write(
    Future<void> Function() action,
    String successMessage,
    Emitter<EventListState> emit,
  ) async {
    try {
      await action();
      final List<Event> events = await _repository.getEvents();
      emit(
        EventListState(
          status: EventListStatus.success,
          events: _sorted(events),
          lastMessage: successMessage,
        ),
      );
    } catch (error) {
      emit(
        EventListState(
          status: EventListStatus.failure,
          events: state.events,
          errorMessage: '$error',
        ),
      );
    }
  }

  /// Daftar kegiatan selalu terurut waktu mulai (M3.3).
  List<Event> _sorted(List<Event> events) {
    final List<Event> sorted = [...events];
    sorted.sort((Event a, Event b) => a.startAt.compareTo(b.startAt));
    return List<Event>.unmodifiable(sorted);
  }
}
