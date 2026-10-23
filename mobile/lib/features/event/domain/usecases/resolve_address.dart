import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/geo.dart';
import '../repositories/event_repository.dart';

/// Parameter reverse geocoding.
class ResolveAddressParams extends Equatable {
  const ResolveAddressParams(this.point);

  final GeoPoint point;

  @override
  List<Object?> get props => [point];
}

/// Mengubah koordinat menjadi alamat (M3, "alamat otomatis").
class ResolveAddress implements UseCase<String, ResolveAddressParams> {
  const ResolveAddress(this._repository);

  final EventRepository _repository;

  @override
  Future<String> call(ResolveAddressParams params) {
    return _repository.resolveAddress(params.point);
  }
}
