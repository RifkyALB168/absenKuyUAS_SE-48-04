import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/core/utils/geo.dart';

void main() {
  group('haversineDistanceMeters', () {
    test('jarak titik yang sama nol', () {
      const GeoPoint point = GeoPoint(-6.973, 107.63);

      expect(point.distanceTo(point), 0);
    });

    test('selisih satu derajat lintang sekitar 111 km', () {
      final double distance = const GeoPoint(
        0,
        0,
      ).distanceTo(const GeoPoint(1, 0));

      // 1 derajat busur bumi = radius * pi / 180.
      expect(distance, closeTo(111194.93, 1));
    });

    test('simetris terhadap urutan argumen', () {
      const GeoPoint a = GeoPoint(-6.973, 107.63);
      const GeoPoint b = GeoPoint(-6.975, 107.635);

      expect(a.distanceTo(b), closeTo(b.distanceTo(a), 0.0001));
    });
  });

  group('GeoPoint.isWithin', () {
    const GeoPoint base = GeoPoint(-6.9732, 107.6304);

    test('benar di dalam radius', () {
      // Sekitar 11 meter dari base.
      const GeoPoint near = GeoPoint(-6.9733, 107.6304);

      expect(base.isWithin(near, 100), isTrue);
    });

    test('salah di luar radius', () {
      const GeoPoint far = GeoPoint(-6.9799, 107.6304);

      expect(base.isWithin(far, 100), isFalse);
    });
  });

  group('GeoBounds.fromPoints', () {
    test('menghitung kotak, tengah, dan rentang', () {
      final GeoBounds bounds = GeoBounds.fromPoints(const [
        GeoPoint(-6.98, 107.62),
        GeoPoint(-6.96, 107.65),
        GeoPoint(-6.97, 107.63),
      ]);

      expect(bounds.southWest, const GeoPoint(-6.98, 107.62));
      expect(bounds.northEast, const GeoPoint(-6.96, 107.65));
      expect(bounds.center.latitude, closeTo(-6.97, 1e-9));
      expect(bounds.center.longitude, closeTo(107.635, 1e-9));
      expect(bounds.latitudeSpan, closeTo(0.02, 1e-9));
      expect(bounds.longitudeSpan, closeTo(0.03, 1e-9));
    });

    test('satu titik menghasilkan kotak berukuran nol', () {
      final GeoBounds bounds = GeoBounds.fromPoints(const [
        GeoPoint(-6.97, 107.63),
      ]);

      expect(bounds.latitudeSpan, 0);
      expect(bounds.longitudeSpan, 0);
      expect(bounds.center, const GeoPoint(-6.97, 107.63));
    });

    test('melempar ArgumentError untuk daftar kosong', () {
      expect(() => GeoBounds.fromPoints(const []), throwsArgumentError);
    });
  });
}
