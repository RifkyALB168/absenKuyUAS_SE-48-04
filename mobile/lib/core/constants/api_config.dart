/// Konfigurasi koneksi ke backend REST API.
///
/// Nilai default `10.0.2.2` adalah alamat localhost komputer jika dilihat
/// dari emulator Android. Untuk HP fisik atau server yang sudah di-deploy,
/// ganti saat menjalankan aplikasi tanpa mengubah kode:
///
/// ```
/// flutter run --dart-define=API_BASE_URL=https://api.contoh.com
/// ```
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const Duration timeout = Duration(seconds: 15);

  /// Kunci Google Geocoding API untuk alamat otomatis (M3).
  ///
  /// Tidak ditulis di kode. Isi saat menjalankan aplikasi:
  /// `flutter run --dart-define=GEOCODING_API_KEY=xxxxxxxx`.
  static const String geocodingApiKey = String.fromEnvironment(
    'GEOCODING_API_KEY',
  );

  /// Basis Google Geocoding API.
  static const String geocodingBaseUrl = 'https://maps.googleapis.com/maps/api';
}
