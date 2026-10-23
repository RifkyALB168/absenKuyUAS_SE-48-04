import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/event_repository.dart';
import 'event_address_event.dart';
import 'event_address_state.dart';

/// Mencari alamat dari koordinat untuk form kegiatan (M3.6).
class EventAddressBloc extends Bloc<EventAddressEvent, EventAddressState> {
  EventAddressBloc(this._repository) : super(const EventAddressState()) {
    on<EventAddressLookupRequested>(_onLookupRequested);
    on<EventAddressCleared>(_onCleared);
  }

  final EventRepository _repository;

  Future<void> _onLookupRequested(
    EventAddressLookupRequested event,
    Emitter<EventAddressState> emit,
  ) async {
    emit(const EventAddressState(status: EventAddressStatus.loading));
    try {
      final String address = await _repository.resolveAddress(event.point);
      emit(
        EventAddressState(status: EventAddressStatus.success, address: address),
      );
    } catch (error) {
      // Geocoding gagal tidak menghentikan proses; alamat diganti koordinat.
      emit(
        EventAddressState(
          status: EventAddressStatus.failure,
          errorMessage: '$error',
        ),
      );
    }
  }

  void _onCleared(EventAddressCleared event, Emitter<EventAddressState> emit) {
    emit(const EventAddressState());
  }
}
