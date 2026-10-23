import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/event_repository.dart';

/// Parameter penghapusan kegiatan.
class DeleteEventParams extends Equatable {
  const DeleteEventParams(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Menghapus kegiatan (endpoint `DELETE /events/:id`).
class DeleteEvent implements UseCase<void, DeleteEventParams> {
  const DeleteEvent(this._repository);

  final EventRepository _repository;

  @override
  Future<void> call(DeleteEventParams params) {
    return _repository.deleteEvent(params.id);
  }
}
