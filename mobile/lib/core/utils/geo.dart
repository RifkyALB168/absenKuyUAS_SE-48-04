import 'dart:math' as math;

/// Titik koordinat di permukaan bumi, derajat desimal (WGS84).
///
/// Dipakai oleh M5 (peta lokasi: marker, radius, titik presensi) dan M4
/// (validasi jarak presensi). Tidak bergantung pada package peta Flutter,
/// sehingga dapat dipakai juga oleh layer domain.
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  /// Lintang, dari -90 (selatan) sampai 90 (utara).
  final double latitude;

  /// Bujur, dari -180 (barat) sampai 180 (timur).
  final double longitude;

  /// Jarak ke [other] di permukaan bumi, dalam meter (rumus Haversine).
  double distanceTo(GeoPoint other) => haversineDistanceMeters(this, other);

  /// Benar jika [other] tidak lebih jauh dari [radiusMeters] dari titik ini.
  bool isWithin(GeoPoint other, double radiusMeters) =>
      distanceTo(other) <= radiusMeters;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}

/// Radius rata-rata bumi dalam meter, dipakai [haversineDistanceMeters].
const double earthRadiusMeters = 6371000;

double _toRadians(double degrees) => degrees * math.pi / 180;

/// Jarak lingkaran besar antara [a] dan [b] dalam meter (rumus Haversine).
///
/// Hasilnya jarak garis lurus di atas permukaan bola bumi; cukup akurat untuk
/// radius geofence puluhan sampai ratusan meter.
double haversineDistanceMeters(GeoPoint a, GeoPoint b) {
  final double deltaLat = _toRadians(b.latitude - a.latitude);
  final double deltaLng = _toRadians(b.longitude - a.longitude);
  final double lat1 = _toRadians(a.latitude);
  final double lat2 = _toRadians(b.latitude);

  final double sinHalfLat = math.sin(deltaLat / 2);
  final double sinHalfLng = math.sin(deltaLng / 2);
  final double h =
      sinHalfLat * sinHalfLat +
      math.cos(lat1) * math.cos(lat2) * sinHalfLng * sinHalfLng;

  // Pembulatan floating point dapat membuat h sedikit di atas 1.
  final double clamped = h > 1 ? 1 : h;
  return 2 * earthRadiusMeters * math.asin(math.sqrt(clamped));
}

/// Kotak batas (bounding box) untuk memuat semua marker dalam satu tampilan
/// peta (M5).
///
/// Menghitung kotak ini dari daftar titik presensi memungkinkan peta di-zoom
/// otomatis ke semua lokasi kegiatan tanpa menyentuh widget peta.
class GeoBounds {
  const GeoBounds({required this.southWest, required this.northEast});

  /// Sudut barat daya (lintang & bujur terkecil).
  final GeoPoint southWest;

  /// Sudut timur laut (lintang & bujur terbesar).
  final GeoPoint northEast;

  /// Kotak terkecil yang memuat semua [points].
  ///
  /// Melempar [ArgumentError] jika [points] kosong, karena kotak batas tidak
  /// punya arti tanpa titik. Titik tunggal menghasilkan kotak berukuran nol.
  factory GeoBounds.fromPoints(Iterable<GeoPoint> points) {
    final Iterator<GeoPoint> iterator = points.iterator;
    if (!iterator.moveNext()) {
      throw ArgumentError.value(points, 'points', 'Minimal satu titik');
    }

    double minLat = iterator.current.latitude;
    double maxLat = iterator.current.latitude;
    double minLng = iterator.current.longitude;
    double maxLng = iterator.current.longitude;

    while (iterator.moveNext()) {
      final GeoPoint point = iterator.current;
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    return GeoBounds(
      southWest: GeoPoint(minLat, minLng),
      northEast: GeoPoint(maxLat, maxLng),
    );
  }

  /// Titik tengah kotak, titik awal yang wajar untuk kamera peta.
  GeoPoint get center => GeoPoint(
    (southWest.latitude + northEast.latitude) / 2,
    (southWest.longitude + northEast.longitude) / 2,
  );

  /// Selisih lintang (derajat) antara sisi utara dan selatan.
  double get latitudeSpan => northEast.latitude - southWest.latitude;

  /// Selisih bujur (derajat) antara sisi timur dan barat.
  double get longitudeSpan => northEast.longitude - southWest.longitude;
}
