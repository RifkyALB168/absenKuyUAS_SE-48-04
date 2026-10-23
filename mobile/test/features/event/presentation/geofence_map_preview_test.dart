import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:absen_kuy/core/utils/geo.dart';
import 'package:absen_kuy/features/event/presentation/widgets/geofence_map_preview.dart';

void main() {
  const GeoPoint center = GeoPoint(-6.9732, 107.6304);
  const Size size = Size(200, 200);

  group('GeofenceMapPreview.pointAt', () {
    test('ketukan di tengah mengembalikan titik pusat', () {
      final GeoPoint point = GeofenceMapPreview.pointAt(
        const Offset(100, 100),
        size,
        center,
        50,
      );

      expect(point.latitude, closeTo(center.latitude, 1e-9));
      expect(point.longitude, closeTo(center.longitude, 1e-9));
    });

    test('ketukan di kanan menaikkan bujur', () {
      final GeoPoint point = GeofenceMapPreview.pointAt(
        const Offset(150, 100),
        size,
        center,
        50,
      );

      expect(point.longitude, greaterThan(center.longitude));
      expect(point.latitude, closeTo(center.latitude, 1e-9));
    });

    test('ketukan di atas menaikkan lintang', () {
      final GeoPoint point = GeofenceMapPreview.pointAt(
        const Offset(100, 50),
        size,
        center,
        50,
      );

      expect(point.latitude, greaterThan(center.latitude));
      expect(point.longitude, closeTo(center.longitude, 1e-9));
    });

    test('pergeseran satu radius sama dengan radius meter', () {
      final double radiusPx = GeofenceMapPreview.radiusPixels(size);
      final GeoPoint point = GeofenceMapPreview.pointAt(
        Offset(100 + radiusPx, 100),
        size,
        center,
        50,
      );

      expect(center.distanceTo(point), closeTo(50, 1));
    });
  });
}
