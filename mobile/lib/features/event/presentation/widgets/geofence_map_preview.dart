import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Peta titik & radius geofence.
///
/// Peta digambar manual dengan [CustomPaint] supaya layar bisa jalan tanpa
/// Google Maps API key. Tidak ada gestur, tidak ada kamera, dan tidak ada
/// permintaan jaringan: semua bentuknya tetap.
///
/// Saat peta sungguhan dipakai, ganti [Positioned.fill] di [_MapCanvas]
/// dengan widget `GoogleMap` dan biarkan overlay di atasnya apa adanya.
class GeofenceMapPreview extends StatelessWidget {
  const GeofenceMapPreview({
    super.key,
    required this.radiusMeter,
    this.centerLabel = 'Student Center',
    this.showTooltip = true,
    this.showRadiusLabel = true,
  });

  /// Radius lingkaran geofence dalam meter.
  final int radiusMeter;

  /// Nama titik tengah yang tampil di bawah pin.
  final String centerLabel;

  /// Kartu petunjuk "Geser peta untuk tentukan titik tengah".
  final bool showTooltip;

  /// Label "R ≈ 50 Meter" di atas lingkaran.
  final bool showRadiusLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        final Offset center = Offset(size.width / 2, size.height * 0.44);
        final double radius = radiusMeter * _pixelsPerMeter;

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(
                  center: center,
                  radius: radius,
                  centerLabel: centerLabel,
                ),
              ),
            ),
            if (showRadiusLabel)
              Positioned(
                left: center.dx - 45,
                top: center.dy - radius - 10,
                child: _RadiusLabel(radiusMeter: radiusMeter),
              ),
            if (showTooltip)
              Positioned(
                left: center.dx - 100,
                top: center.dy - radius - 50,
                child: const _Tooltip(),
              ),
            const Positioned(right: 12, top: 12, child: _ZoomControls()),
          ],
        );
      },
    );
  }
}

/// Skala peta: 50 meter kira-kira 78 piksel, sama dengan desain.
const double _pixelsPerMeter = 1.56;

/// Label "R ≈ 50 Meter" berbentuk pil putih.
class _RadiusLabel extends StatelessWidget {
  const _RadiusLabel({required this.radiusMeter});

  final int radiusMeter;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(100),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x1A0F172A),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.adjust, size: 13, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            'R ≈ $radiusMeter Meter',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Kartu petunjuk gelap di atas peta.
class _Tooltip extends StatelessWidget {
  const _Tooltip();

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 210),
    decoration: BoxDecoration(
      color: const Color(0xFF1F2937),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.touch_app_outlined, size: 15, color: Colors.white),
        SizedBox(width: 7),
        Flexible(
          child: Text(
            'Geser peta untuk tentukan titik tengah',
            style: TextStyle(
              fontSize: 11,
              height: 1.3,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Tombol bulat di kanan bawah peta (target, +, −).
class _ZoomControls extends StatelessWidget {
  const _ZoomControls();

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      _RoundButton(
        // Zoom reset button
        icon: Icons.redo,
        background: AppColors.primary,
        foreground: AppColors.surface,
      ),
      const SizedBox(height: 10),
      _RoundButton(icon: Icons.add, background: AppColors.surface),
      const SizedBox(height: 8),
      _RoundButton(icon: Icons.remove, background: AppColors.surface),
    ],
  );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.background,
    this.foreground = AppColors.textPrimary,
  });

  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      color: background,
      shape: BoxShape.circle,
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x1A0F172A),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Icon(icon, size: 18, color: foreground),
  );
}

/// Menggambar jalan, blok gedung, pohon, lingkaran radius, dan pin tengah.
class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.center,
    required this.radius,
    required this.centerLabel,
  });

  final Offset center;
  final double radius;
  final String centerLabel;

  /// Titik pohon sebagai pecahan dari ukuran peta.
  static const List<Offset> _trees = <Offset>[
    Offset(0.14, 0.20),
    Offset(0.30, 0.13),
    Offset(0.62, 0.16),
    Offset(0.80, 0.24),
    Offset(0.24, 0.40),
    Offset(0.70, 0.38),
    Offset(0.16, 0.58),
    Offset(0.44, 0.72),
    Offset(0.82, 0.62),
    Offset(0.36, 0.86),
  ];

  /// Blok gedung: kiri, atas, lebar, tinggi (pecahan ukuran peta).
  static const List<Rect> _buildings = <Rect>[
    Rect.fromLTWH(0.08, 0.05, 0.22, 0.10),
    Rect.fromLTWH(0.58, 0.05, 0.26, 0.09),
    Rect.fromLTWH(0.44, 0.22, 0.18, 0.08),
    Rect.fromLTWH(0.10, 0.66, 0.20, 0.12),
    Rect.fromLTWH(0.62, 0.74, 0.24, 0.12),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _paintGround(canvas, size);
    _paintRoads(canvas, size);
    _paintBuildings(canvas, size);
    _paintTrees(canvas, size);
    _paintRadius(canvas);
    _paintCenterPin(canvas);
    _paintMapLabels(canvas, size);
  }

  void _paintGround(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF1F4F1),
    );
  }

  void _paintRoads(Canvas canvas, Size size) {
    final Paint road = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final Paint thinRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    // Jalan utama horizontal dan vertikal.
    canvas.drawLine(
      Offset(0, size.height * 0.32),
      Offset(size.width, size.height * 0.30),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.40, 0),
      Offset(size.width * 0.42, size.height),
      road,
    );
    // Jalan sekunder.
    canvas.drawLine(
      Offset(0, size.height * 0.62),
      Offset(size.width, size.height * 0.60),
      thinRoad,
    );
    canvas.drawLine(
      Offset(size.width * 0.78, 0),
      Offset(size.width * 0.76, size.height * 0.55),
      thinRoad,
    );
  }

  void _paintBuildings(Canvas canvas, Size size) {
    final Paint fill = Paint()..color = const Color(0xFFE4E8E4);
    final Paint border = Paint()
      ..color = const Color(0xFFD6DBD6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final Rect unit in _buildings) {
      final Rect rect = Rect.fromLTWH(
        unit.left * size.width,
        unit.top * size.height,
        unit.width * size.width,
        unit.height * size.height,
      );
      final RRect rounded = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(4),
      );
      canvas.drawRRect(rounded, fill);
      canvas.drawRRect(rounded, border);
    }
  }

  void _paintTrees(Canvas canvas, Size size) {
    final Paint canopy = Paint()..color = const Color(0xFFBFE3C6);
    final Paint trunk = Paint()..color = const Color(0xFF9FCFA9);

    for (final Offset unit in _trees) {
      final Offset at = Offset(unit.dx * size.width, unit.dy * size.height);
      canvas.drawCircle(at, 7, canopy);
      canvas.drawCircle(at.translate(-0.4, 0), 4, trunk);
    }
  }

  void _paintRadius(Canvas canvas) {
    // Isian biru transparan di dalam lingkaran.
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = AppColors.primary.withValues(alpha: 0.07),
    );
    // Garis putus-putus.
    const int dashes = 44;
    final double step = (2 * math.pi) / dashes;
    final Paint stroke = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (int i = 0; i < dashes; i++) {
      if (i.isEven) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          i * step,
          step,
          false,
          stroke,
        );
      }
    }
  }

  void _paintCenterPin(Canvas canvas) {
    // Bayangan pin.
    canvas.drawCircle(
      center.translate(0, 3),
      13,
      Paint()..color = const Color(0x22000000),
    );
    // Badan pin.
    canvas.drawCircle(center, 12, Paint()..color = AppColors.primary);
    canvas.drawCircle(center, 10, Paint()..color = AppColors.surface);
    canvas.drawCircle(center, 5, Paint()..color = AppColors.primary);

    // Pil putih berisi nama titik di atas pin.
    final TextPainter label = TextPainter(
      text: TextSpan(
        text: centerLabel,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final Rect box = Rect.fromCenter(
      center: center.translate(0, -28),
      width: label.width + 14,
      height: 19,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(6)),
      Paint()..color = AppColors.surface,
    );
    label.paint(
      canvas,
      Offset(box.center.dx - label.width / 2, box.center.dy - label.height / 2),
    );
  }

  void _paintMapLabels(Canvas canvas, Size size) {
    _label(canvas, 'Rektorat', Offset(size.width * 0.19, size.height * 0.34));
    _label(canvas, 'GSO', Offset(size.width * 0.68, size.height * 0.33));
    _label(
      canvas,
      'Open Library',
      Offset(size.width * 0.30, size.height * 0.80),
    );
    _label(
      canvas,
      'Kawasan Kampus Telkom Univ',
      Offset(size.width * 0.33, size.height * 0.93),
      color: AppColors.primary,
    );
  }

  void _label(
    Canvas canvas,
    String text,
    Offset at, {
    Color color = AppColors.textSecondary,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.center != center ||
      oldDelegate.centerLabel != centerLabel;
}
