import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Parameter daftar kegiatan milik satu kelompok.
class GetGroupEventsParams extends Equatable {
  const GetGroupEventsParams(this.groupId);

  final String groupId;

  @override
  List<Object?> get props => [groupId];
}

/// Mengambil kegiatan milik satu kelompok (endpoint `GET /groups/:id/events`).
class GetGroupEvents implements UseCase<List<Event>, GetGroupEventsParams> {
  const GetGroupEvents(this._repository);

  final EventRepository _repository;

  @override
  Future<List<Event>> call(GetGroupEventsParams params) {
    return _repository.getGroupEvents(params.groupId);
  }
}
