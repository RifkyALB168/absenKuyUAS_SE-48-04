import '../../../../core/utils/geo.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_data_source.dart';
import '../datasources/geocoding_remote_data_source.dart';
import '../models/event_model.dart';

/// Implementasi [EventRepository] di atas REST API kegiatan.
class EventRepositoryImpl implements EventRepository {
  const EventRepositoryImpl({
    required EventRemoteDataSource remoteDataSource,
    required GeocodingRemoteDataSource geocodingDataSource,
  }) : _remote = remoteDataSource,
       _geocoding = geocodingDataSource;

  final EventRemoteDataSource _remote;
  final GeocodingRemoteDataSource _geocoding;

  @override
  Future<List<Event>> getEvents({String? groupId}) async {
    final List<EventModel> models = await _remote.fetchEvents(groupId: groupId);
    return List<Event>.unmodifiable(models);
  }

  @override
  Future<List<Event>> getGroupEvents(String groupId) async {
    final List<EventModel> models = await _remote.fetchGroupEvents(groupId);
    return List<Event>.unmodifiable(models);
  }

  @override
  Future<Event> getEventById(String id) {
    return _remote.fetchEventById(id);
  }

  @override
  Future<Event> createEvent(Event event) {
    return _remote.createEvent(EventModel.fromEntity(event));
  }

  @override
  Future<Event> updateEvent(Event event) {
    return _remote.updateEvent(EventModel.fromEntity(event));
  }

  @override
  Future<void> deleteEvent(String id) => _remote.deleteEvent(id);

  @override
  Future<String> resolveAddress(GeoPoint point) =>
      _geocoding.reverseGeocode(point);
}
