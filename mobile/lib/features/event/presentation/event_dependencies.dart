import '../data/repositories/dummy_event_repository.dart';
import '../domain/repositories/event_repository.dart';

EventRepository? _repository;

/// Repositori yang dipakai UI fitur kegiatan.
///
/// Sementara ini mengembalikan [DummyEventRepository] karena backend REST belum
/// ada. Ganti ke `EventRepositoryImpl` setelah endpoint siap, tanpa mengubah
/// halaman.
EventRepository get eventRepository => _repository ??= DummyEventRepository();

/// Menimpa repositori, mis. pada pengujian atau setelah backend REST siap.
void useEventRepository(EventRepository repository) => _repository = repository;
