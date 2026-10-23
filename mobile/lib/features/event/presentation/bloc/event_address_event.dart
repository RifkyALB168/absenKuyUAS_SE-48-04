import 'package:equatable/equatable.dart';

import '../../../../core/utils/geo.dart';

/// Aksi yang diterima [EventAddressBloc].
sealed class EventAddressEvent extends Equatable {
  const EventAddressEvent();

  @override
  List<Object?> get props => const [];
}

/// Mencari alamat untuk [point] (M3.6, alamat otomatis).
class EventAddressLookupRequested extends EventAddressEvent {
  const EventAddressLookupRequested(this.point);

  final GeoPoint point;

  @override
  List<Object?> get props => [point];
}

/// Menghapus alamat yang tampil, mis. saat pin dipindah.
class EventAddressCleared extends EventAddressEvent {
  const EventAddressCleared();
}
