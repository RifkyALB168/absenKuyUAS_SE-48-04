import 'package:flutter/material.dart';

import '../../domain/entities/attendance_history_item.dart';
import 'status_badge.dart';
import 'thumbnail_icon.dart';

/// Kartu riwayat kehadiran
class HistoryCard extends StatelessWidget {
  final AttendanceHistoryItem data;

  const HistoryCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: data.borderColor ?? const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail / Ikon di kiri
          ThumbnailIcon(type: data.thumbnailType),
          const SizedBox(width: 12),

          // Kolom Title, Date, Subtitle di tengah (Expanded)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.organization != null) ...[
                  Text(
                    data.organization!,
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.date,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSubtitleContent(data),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Status Badge di kanan atas
          StatusBadge(
            text: data.badgeText,
            textColor: data.badgeTextColor,
            backgroundColor: data.badgeBackgroundColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitleContent(AttendanceHistoryItem item) {
    final isAlert = item.thumbnailType == ThumbnailType.alert;
    final isDoc = item.thumbnailType == ThumbnailType.document;
    final accentColor =
        isAlert ? const Color(0xFFE11D48) : const Color(0xFF2563EB);

    final subtitleRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDoc) ...[
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              isAlert
                  ? Icons.error_outline_rounded
                  : Icons.location_on_outlined,
              size: 14,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            item.subtitle,
            style: TextStyle(
              color: isAlert
                  ? const Color(0xFF9F1239)
                  : isDoc
                      ? const Color(0xFF334155)
                      : const Color(0xFF475569),
              fontSize: 12,
              fontWeight: isDoc || isAlert ? FontWeight.w500 : FontWeight.w400,
              height: 1.35,
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDoc || isAlert)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isAlert
                  ? const Color(0xFFFFF1F2)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isAlert
                    ? const Color(0xFFFECDD3)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: subtitleRow,
          )
        else
          subtitleRow,
        if (item.actionLink != null) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  item.actionLink!,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                isAlert
                    ? Icons.chevron_right_rounded
                    : Icons.arrow_forward_rounded,
                size: 14,
                color: accentColor,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
