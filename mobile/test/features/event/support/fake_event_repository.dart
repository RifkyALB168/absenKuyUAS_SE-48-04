import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/domain/entities/event.dart';
import 'package:absen_kuy/features/event/domain/repositories/event_repository.dart';

/// Repositori palsu tanpa jeda untuk pengujian.
class FakeEventRepository implements EventRepository {
  FakeEventRepository({
    List<Event>? events,
    this.failOnLoad = false,
    this.address = 'Jl. Contoh No. 1, Bandung',
  }) : _events = <Event>[...?events];

  final List<Event> _events;

  /// Alamat yang dikembalikan [resolveAddress].
  final String address;

  /// Bila true, [getEvents] melempar error untuk menguji state gagal.
  final bool failOnLoad;

  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;

  @override
  Future<List<Event>> getEvents({String? groupId}) async {
    if (failOnLoad) throw StateError('gagal memuat');
    if (groupId == null) return List<Event>.of(_events);
    return _events
        .where((Event event) => event.groupId == groupId)
        .toList(growable: false);
  }

  @override
  Future<List<Event>> getGroupEvents(String groupId) =>
      getEvents(groupId: groupId);

  @override
  Future<Event> getEventById(String id) async =>
      _events.firstWhere((Event event) => event.id == id);

  @override
  Future<Event> createEvent(Event event) async {
    createCalls++;
    final Event saved = event.copyWith(id: '${_events.length + 1}');
    _events.add(saved);
    return saved;
  }

  @override
  Future<Event> updateEvent(Event event) async {
    updateCalls++;
    final int index = _events.indexWhere((Event item) => item.id == event.id);
    if (index >= 0) _events[index] = event;
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    deleteCalls++;
    _events.removeWhere((Event event) => event.id == id);
  }

  @override
  Future<String> resolveAddress(GeoPoint point) async => address;
}
