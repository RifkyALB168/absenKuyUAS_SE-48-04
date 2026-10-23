import 'package:equatable/equatable.dart';

import '../../domain/entities/event.dart';

/// Tahap pemuatan daftar kegiatan.
enum EventListStatus { initial, loading, success, failure }

/// State [EventListBloc].
class EventListState extends Equatable {
  const EventListState({
    this.status = EventListStatus.initial,
    this.events = const <Event>[],
    this.errorMessage,
    this.lastMessage,
  });

  final EventListStatus status;

  /// Daftar kegiatan terurut waktu mulai.
  final List<Event> events;

  /// Pesan kegagalan yang dapat ditampilkan (M9).
  final String? errorMessage;

  /// Pesan sekali tampil setelah aksi berhasil, mis. "Kegiatan disimpan".
  final String? lastMessage;

  bool get isLoading => status == EventListStatus.loading;
  bool get isFailure => status == EventListStatus.failure;
  bool get isEmpty => status == EventListStatus.success && events.isEmpty;

  EventListState copyWith({
    EventListStatus? status,
    List<Event>? events,
    String? errorMessage,
    String? lastMessage,
  }) {
    return EventListState(
      status: status ?? this.status,
      events: events ?? this.events,
      errorMessage: errorMessage,
      lastMessage: lastMessage,
    );
  }

  @override
  List<Object?> get props => [status, events, errorMessage, lastMessage];
}
