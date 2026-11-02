import 'package:flutter/material.dart';

import '../../domain/entities/attendance_history_item.dart';

/// Thumbnail icon di kartu riwayat presensi
class ThumbnailIcon extends StatelessWidget {
  final ThumbnailType type;

  const ThumbnailIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final (bgColor, borderColor, badgeIcon, badgeColor, content) = switch (type) {
      ThumbnailType.selfie => (
        const Color(0xFFF1F5F9),
        const Color(0xFFE2E8F0),
        Icons.check_circle_rounded,
        const Color(0xFF10B981),
        const Icon(Icons.person_rounded, size: 26, color: Color(0xFF64748B)),
      ),
      ThumbnailType.document => (
        const Color(0xFFFEF3C7),
        const Color(0xFFFDE68A),
        Icons.check_circle_rounded,
        const Color(0xFFD97706),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 20, color: Color(0xFFD97706)),
            Text(
              'SURAT',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: Color(0xE6D97706),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      ThumbnailType.alert => (
        const Color(0xFFFFE4E6),
        const Color(0xFFFECDD3),
        Icons.cancel_rounded,
        const Color(0xFFE11D48),
        const Icon(Icons.location_off_outlined, size: 24, color: Color(0xFFE11D48)),
      ),
    };

    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: content,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(badgeIcon, size: 14, color: badgeColor),
            ),
          ),
        ],
      ),
    );
  }
}
