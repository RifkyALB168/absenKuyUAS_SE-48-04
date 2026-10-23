import 'package:equatable/equatable.dart';

import '../../../../core/utils/geo.dart';

/// Tahap pencarian alamat.
enum EventAddressStatus { initial, loading, success, failure }

/// State [EventAddressBloc].
class EventAddressState extends Equatable {
  const EventAddressState({
    this.status = EventAddressStatus.initial,
    this.address,
    this.errorMessage,
  });

  final EventAddressStatus status;

  /// Alamat hasil geocoding.
  final String? address;

  /// Pesan kegagalan; alamat dapat diganti koordinat (M3.6).
  final String? errorMessage;

  bool get isLoading => status == EventAddressStatus.loading;

  EventAddressState copyWith({
    EventAddressStatus? status,
    String? address,
    String? errorMessage,
  }) {
    return EventAddressState(
      status: status ?? this.status,
      address: address,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, address, errorMessage];
}

/// Teks alamat yang dipakai form: alamat hasil geocoding, atau koordinat bila
/// geocoding gagal (M3.6).
String formatAddressFallback(GeoPoint point, EventAddressState state) {
  final String? address = state.address;
  if (address != null && address.isNotEmpty) return address;
  return '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
}
