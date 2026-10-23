import '../../../../core/utils/geo.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';

/// Repositori sementara agar UI (M3/M5) dapat dikembangkan tanpa backend.
///
/// Semua data disimpan di memori dan hilang saat aplikasi ditutup. HAPUS kelas
/// ini setelah endpoint REST siap, lalu pakai `EventRepositoryImpl`.
class DummyEventRepository implements EventRepository {
  DummyEventRepository({List<Event>? seed})
    : _events = <Event>[...(seed ?? _seedEvents())];

  final List<Event> _events;

  /// Jeda buatan supaya state loading ikut terlihat saat pengembangan.
  static const Duration _latency = Duration(milliseconds: 300);

  int _nextId = 100;

  @override
  Future<List<Event>> getEvents({String? groupId}) async {
    await Future<void>.delayed(_latency);
    if (groupId == null) return List<Event>.unmodifiable(_events);
    return List<Event>.unmodifiable(
      _events.where((Event event) => event.groupId == groupId),
    );
  }

  @override
  Future<List<Event>> getGroupEvents(String groupId) =>
      getEvents(groupId: groupId);

  @override
  Future<Event> getEventById(String id) async {
    await Future<void>.delayed(_latency);
    return _events.firstWhere(
      (Event event) => event.id == id,
      orElse: () => throw StateError('Kegiatan $id tidak ditemukan'),
    );
  }

  @override
  Future<Event> createEvent(Event event) async {
    await Future<void>.delayed(_latency);
    final Event saved = event.copyWith(
      id: '${_nextId++}',
      createdAt: DateTime.now(),
    );
    _events.add(saved);
    return saved;
  }

  @override
  Future<Event> updateEvent(Event event) async {
    await Future<void>.delayed(_latency);
    final int index = _events.indexWhere((Event item) => item.id == event.id);
    if (index < 0) throw StateError('Kegiatan ${event.id} tidak ditemukan');
    _events[index] = event;
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    await Future<void>.delayed(_latency);
    _events.removeWhere((Event event) => event.id == id);
  }

  @override
  Future<String> resolveAddress(GeoPoint point) async {
    await Future<void>.delayed(_latency);
    // Alamat contoh. Geocoding asli memakai Google Geocoding API (M3.6).
    return 'Jl. Telekomunikasi No. 1, Terusan Buahbatu, Bandung';
  }
}

List<Event> _seedEvents() {
  final DateTime today = DateTime.now();
  final DateTime startOfToday = DateTime(today.year, today.month, today.day);

  return <Event>[
    Event(
      id: '1',
      groupId: '1',
      title: 'Rapat Pleno & Latihan Rutin',
      description:
          'Evaluasi program kerja bulan ini dan latihan rutin anggota.',
      location: const EventLocation(
        point: GeoPoint(-6.9732, 107.6304),
        radiusMeters: 50,
        address: 'Gedung TULT, Telkom University',
        placeName: 'Gedung TULT',
      ),
      startAt: startOfToday.add(const Duration(hours: 9)),
      endAt: startOfToday.add(const Duration(hours: 11)),
      status: EventStatus.published,
    ),
    Event(
      id: '2',
      groupId: '2',
      title: 'Bakti Sosial Himpunan',
      description: 'Kegiatan sosial di desa binaan.',
      location: const EventLocation(
        point: GeoPoint(-6.9755, 107.6338),
        radiusMeters: 100,
        address: 'Student Center Telkom University',
        placeName: 'Student Center',
      ),
      startAt: startOfToday.add(const Duration(days: 2, hours: 8)),
      endAt: startOfToday.add(const Duration(days: 2, hours: 12)),
      status: EventStatus.published,
    ),
    Event(
      id: '3',
      groupId: '3',
      title: 'Rapat Koordinasi Kepanitiaan',
      description: 'Persiapan acara dies natalis.',
      location: const EventLocation(
        point: GeoPoint(-6.9701, 107.6289),
        radiusMeters: 30,
        address: 'Gedung Tokong Nanas',
        placeName: 'Gedung Tokong Nanas',
      ),
      startAt: startOfToday.add(const Duration(hours: 15)),
      endAt: startOfToday.add(const Duration(hours: 17)),
      status: EventStatus.draft,
    ),
  ];
}
