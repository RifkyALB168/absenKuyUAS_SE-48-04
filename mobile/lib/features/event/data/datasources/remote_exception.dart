/// Kegagalan saat berkomunikasi dengan REST API kegiatan (M3/M5).
///
/// Dipakai layer data agar kode pemanggil tidak perlu tahu jenis error
/// transportasi (socket, timeout, atau status HTTP). Pemetaan menjadi pesan
/// yang tampil ke pengguna dikerjakan di layer presentation (M9).
class EventRemoteException implements Exception {
  const EventRemoteException(this.message, {this.statusCode});

  /// Pesan singkat penyebab kegagalan.
  final String message;

  /// Kode status HTTP bila kegagalan berasal dari respons backend.
  final int? statusCode;

  @override
  String toString() => statusCode == null
      ? 'EventRemoteException: $message'
      : 'EventRemoteException($statusCode): $message';
}
