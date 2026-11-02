import 'dart:math' as math;
import 'package:flutter/material.dart';

class AttendanceDetailPage extends StatelessWidget {
  const AttendanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(color: Color(0xFF0F172A)),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detail Kegiatan & Presensi',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Rapat Pleno & Evaluasi Mingguan',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMapGeofenceCard(),
            const SizedBox(height: 16),
            _buildSelfieMetadataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapGeofenceCard() {
    return Container(
      height: 196,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulated Map Area (Building footprint box)
          Positioned(
            top: 14,
            child: Container(
              width: 190,
              height: 122,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.domain_rounded,
                        size: 14,
                        color: Color(0xFF2563EB),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'TULT Lt. 3',
                        style: TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Ruang Rapat UKM 3.04',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Street Banner
          Positioned(
            left: 0,
            right: 0,
            bottom: 22,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: const Color(0xE6FFFFFF),
              child: const Text(
                'JL. TELEKOMUNIKASI (KAMPUS TERPADU)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),

          // Simulated Circular Geofence with Dashed Border
          Positioned(
            top: 6,
            right: 68,
            child: CustomPaint(
              foregroundPainter: _DashedCirclePainter(
                color: const Color(0xFF2563EB),
              ),
              child: Container(
                width: 154,
                height: 154,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x66EFF6FF),
                ),
                child: Stack(
                  children: [
                    // Event Center Marker
                    Positioned(
                      top: 34,
                      right: 28,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x332563EB),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),

                    // User Location Marker (with pulse rings)
                    Positioned(
                      bottom: 26,
                      left: 30,
                      child: Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x262563EB),
                        ),
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF2563EB),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelfieMetadataCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Part: Selfie Proof Image (with 300px fallback placeholder)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/selfie_proof.jpg',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 300,
                color: const Color(0xFFE2E8F0),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person,
                  size: 72,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Middle Part: ListTile 1 (Jadwal Acara)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            minVerticalPadding: 8,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.access_time_rounded,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            title: const Text(
              'JADWAL ACARA',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                'Jumat, 24 Oktober 2026 • 15:30 - 17:30 WIB',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Bottom Part: ListTile 2 (Lokasi Terverifikasi)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            minVerticalPadding: 8,
            isThreeLine: true,
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.domain_rounded,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            title: const Text(
              'LOKASI TERVERIFIKASI',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            subtitle: const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Gedung Tokong Nanas (TULT) Lt. 3\n',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'Jl. Telekomunikasi No. 1, Terusan Buahbatu,',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;

  const _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final radius = (size.width / 2) - 1;
    final center = Offset(size.width / 2, size.height / 2);
    const dashCount = 36;
    const dashAngle = (2 * math.pi) / dashCount;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * dashAngle,
        dashAngle * 0.55,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}

