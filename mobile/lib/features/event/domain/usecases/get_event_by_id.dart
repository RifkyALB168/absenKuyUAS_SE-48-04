import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Parameter pengambilan satu kegiatan.
class GetEventByIdParams extends Equatable {
  const GetEventByIdParams(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Mengambil detail kegiatan (endpoint `GET /events/:id`).
class GetEventById implements UseCase<Event, GetEventByIdParams> {
  const GetEventById(this._repository);

  final EventRepository _repository;

  @override
  Future<Event> call(GetEventByIdParams params) {
    return _repository.getEventById(params.id);
  }
}
