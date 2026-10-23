import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

/// Parameter perubahan kegiatan. [event].id harus terisi.
class UpdateEventParams extends Equatable {
  const UpdateEventParams(this.event);

  final Event event;

  @override
  List<Object?> get props => [event];
}

/// Menyimpan perubahan kegiatan (endpoint `PUT /events/:id`).
class UpdateEvent implements UseCase<Event, UpdateEventParams> {
  const UpdateEvent(this._repository);

  final EventRepository _repository;

  @override
  Future<Event> call(UpdateEventParams params) {
    return _repository.updateEvent(params.event);
  }
}
