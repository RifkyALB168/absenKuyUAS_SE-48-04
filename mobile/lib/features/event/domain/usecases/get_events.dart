import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Filter daftar kegiatan. [groupId] kosong berarti semua kegiatan.
class GetEventsParams extends Equatable {
  const GetEventsParams({this.groupId});

  final String? groupId;

  @override
  List<Object?> get props => [groupId];
}

/// Mengambil daftar kegiatan (endpoint `GET /events`).
class GetEvents implements UseCase<List<Event>, GetEventsParams> {
  const GetEvents(this._repository);

  final EventRepository _repository;

  @override
  Future<List<Event>> call(GetEventsParams params) {
    return _repository.getEvents(groupId: params.groupId);
  }
}
