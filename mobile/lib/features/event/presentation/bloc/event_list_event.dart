import 'package:equatable/equatable.dart';

import '../../domain/entities/event.dart';

/// Aksi yang diterima [EventListBloc].
sealed class EventListEvent extends Equatable {
  const EventListEvent();

  @override
  List<Object?> get props => const [];
}

/// Memuat ulang daftar kegiatan, opsional hanya untuk satu kelompok.
class EventListLoadRequested extends EventListEvent {
  const EventListLoadRequested({this.groupId});

  final String? groupId;

  @override
  List<Object?> get props => [groupId];
}

/// Menyimpan kegiatan baru, lalu memuat ulang daftar.
class EventAdded extends EventListEvent {
  const EventAdded(this.event);

  final Event event;

  @override
  List<Object?> get props => [event];
}

/// Menyimpan perubahan kegiatan, lalu memuat ulang daftar.
class EventChanged extends EventListEvent {
  const EventChanged(this.event);

  final Event event;

  @override
  List<Object?> get props => [event];
}

/// Menghapus kegiatan, lalu memuat ulang daftar.
class EventRemoved extends EventListEvent {
  const EventRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
