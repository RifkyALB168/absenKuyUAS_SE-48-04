import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Parameter pembuatan kegiatan. [event].groupId harus terisi.
class CreateEventParams extends Equatable {
  const CreateEventParams(this.event);

  final Event event;

  @override
  List<Object?> get props => [event];
}

/// Membuat kegiatan baru (endpoint `POST /groups/:id/events`).
class CreateEvent implements UseCase<Event, CreateEventParams> {
  const CreateEvent(this._repository);

  final EventRepository _repository;

  @override
  Future<Event> call(CreateEventParams params) {
    return _repository.createEvent(params.event);
  }
}
