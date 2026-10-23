import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo.dart';

/// Peta sementara untuk M5: menggambar titik kegiatan, lingkaran radius, dan
/// titik lain (mis. titik presensi anggota) tanpa Google Maps.
///
/// Ini pengganti sementara `google_maps_flutter` karena build peta butuh API
/// key dan billing. Setelah key tersedia, ganti isi widget ini dengan
/// `GoogleMap` tanpa mengubah halaman pemakainya.
class GeofenceMapPreview extends StatelessWidget {
  const GeofenceMapPreview({
    super.key,
    required this.center,
    required this.radiusMeters,
    this.markers = const <GeoPoint>[],
    this.currentLocation,
    this.onTapPoint,
    this.height = 220,
  });

  /// Titik kegiatan (pin dan pusat lingkaran radius).
  final GeoPoint center;

  /// Radius geofence dalam meter.
  final double radiusMeters;

  /// Titik tambahan, mis. sebaran titik presensi anggota (M5.2).
  final List<GeoPoint> markers;

  /// Posisi pengguna saat ini, bila ada.
  final GeoPoint? currentLocation;

  /// Dipanggil saat peta diketuk; koordinat hasil ketukan dikembalikan.
  final ValueChanged<GeoPoint>? onTapPoint;

  final double height;

  /// Radius lingkaran dalam piksel, dihitung dari sisi terpendek.
  static double radiusPixels(Size size) =>
      math.min(size.width, size.height) * 0.36;

  /// Mengubah posisi ketukan pada peta menjadi koordinat.
  static GeoPoint pointAt(
    Offset localPosition,
    Size size,
    GeoPoint center,
    double radiusMeters,
  ) {
    final double metersPerPixel = radiusMeters / radiusPixels(size);
    final double eastMeters =
        (localPosition.dx - size.width / 2) * metersPerPixel;
    final double northMeters =
        (size.height / 2 - localPosition.dy) * metersPerPixel;
    return center.offsetBy(eastMeters, northMeters);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Size size = Size(constraints.maxWidth, constraints.maxHeight);
            return GestureDetector(
              onTapUp: onTapPoint == null
                  ? null
                  : (TapUpDetails details) => onTapPoint!(
                      pointAt(
                        details.localPosition,
                        size,
                        center,
                        radiusMeters,
                      ),
                    ),
              child: CustomPaint(
                size: size,
                painter: _GeofenceMapPainter(
                  center: center,
                  radiusMeters: radiusMeters,
                  markers: markers,
                  currentLocation: currentLocation,
                ),
                child: onTapPoint == null
                    ? null
                    : const Align(
                        alignment: Alignment.bottomLeft,
                        child: _MapHint(),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MapHint extends StatelessWidget {
  const _MapHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'Peta sementara • ketuk untuk memindah pin',
        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
    );
  }
}

class _GeofenceMapPainter extends CustomPainter {
  const _GeofenceMapPainter({
    required this.center,
    required this.radiusMeters,
    required this.markers,
    required this.currentLocation,
  });

  final GeoPoint center;
  final double radiusMeters;
  final List<GeoPoint> markers;
  final GeoPoint? currentLocation;

  static const double _metersPerDegreeLat = 111320;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset origin = Offset(size.width / 2, size.height / 2);
    final double radiusPx = GeofenceMapPreview.radiusPixels(size);
    final double metersPerPixel = radiusMeters / radiusPx;

    _paintBackground(canvas, size);
    _paintGrid(canvas, size, radiusPx);

    // Lingkaran radius geofence (M5.1).
    canvas.drawCircle(
      origin,
      radiusPx,
      Paint()..color = AppColors.primaryTint.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      origin,
      radiusPx,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Titik tambahan, mis. titik presensi anggota (M5.2).
    for (final GeoPoint marker in markers) {
      final Offset position = _project(marker, origin, metersPerPixel);
      if (_inside(position, size)) {
        _paintDot(canvas, position, AppColors.success);
      }
    }

    final GeoPoint? current = currentLocation;
    if (current != null) {
      final Offset position = _project(current, origin, metersPerPixel);
      if (_inside(position, size)) {
        _paintDot(canvas, position, AppColors.primary);
      }
    }

    _paintPin(canvas, origin);
  }

  void _paintBackground(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.background);
  }

  void _paintGrid(Canvas canvas, Size size, double radiusPx) {
    final Paint paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    const double step = 24;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  Offset _project(GeoPoint point, Offset origin, double metersPerPixel) {
    final double eastMeters =
        (point.longitude - center.longitude) *
        _metersPerDegreeLat *
        math.cos(center.latitude * math.pi / 180);
    final double northMeters =
        (point.latitude - center.latitude) * _metersPerDegreeLat;
    return Offset(
      origin.dx + eastMeters / metersPerPixel,
      origin.dy - northMeters / metersPerPixel,
    );
  }

  bool _inside(Offset position, Size size) =>
      position.dx >= 0 &&
      position.dy >= 0 &&
      position.dx <= size.width &&
      position.dy <= size.height;

  void _paintDot(Canvas canvas, Offset position, Color color) {
    canvas.drawCircle(position, 7, Paint()..color = AppColors.surface);
    canvas.drawCircle(position, 5, Paint()..color = color);
  }

  void _paintPin(Canvas canvas, Offset position) {
    canvas.drawCircle(
      position,
      9,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _GeofenceMapPainter oldDelegate) =>
      oldDelegate.center != center ||
      oldDelegate.radiusMeters != radiusMeters ||
      oldDelegate.currentLocation != currentLocation ||
      !_sameMarkers(oldDelegate.markers, markers);

  bool _sameMarkers(List<GeoPoint> a, List<GeoPoint> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
