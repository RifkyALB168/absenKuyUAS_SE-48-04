import '../../../../core/utils/geo.dart';
import '../entities/event.dart';

/// Kontrak akses data kegiatan (M3) dan lokasi (M5).
///
/// Layer `presentation` dan `usecases` hanya bergantung pada kontrak ini,
/// sehingga sumber data (REST API dari backend) dapat diganti tanpa mengubah
/// pemanggil.
abstract class EventRepository {
  /// Semua kegiatan, atau hanya milik [groupId] bila diisi.
  Future<List<Event>> getEvents({String? groupId});

  /// Kegiatan milik kelompok [groupId].
  Future<List<Event>> getGroupEvents(String groupId);

  /// Satu kegiatan berdasarkan [id].
  Future<Event> getEventById(String id);

  /// Membuat kegiatan baru pada kelompok [event].groupId.
  Future<Event> createEvent(Event event);

  /// Menyimpan perubahan kegiatan [event].
  Future<Event> updateEvent(Event event);

  /// Menghapus kegiatan [id].
  Future<void> deleteEvent(String id);

  /// Mengubah koordinat [point] menjadi alamat yang dapat dibaca manusia
  /// ("alamat otomatis" pada M3).
  Future<String> resolveAddress(GeoPoint point);
}
