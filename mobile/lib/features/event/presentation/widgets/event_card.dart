import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/event.dart';
import '../event_formatters.dart';

/// Kartu ringkas satu kegiatan pada daftar (M3.3).
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.now,
  });

  final Event event;
  final VoidCallback onTap;

  /// Waktu acuan untuk menentukan status; diisi pada pengujian.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final DateTime reference = now ?? DateTime.now();
    final bool ongoing = event.isOpenAt(reference);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(
              color: ongoing ? AppColors.primary : AppColors.border,
              width: ongoing ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.all(AppTheme.gap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _Badge(
                    label: event.location.placeName ?? 'Lokasi kegiatan',
                    background: AppColors.primaryTint,
                    foreground: AppColors.primary,
                  ),
                  const Spacer(),
                  _StatusBadge(event: event, now: reference),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _MetaRow(
                icon: Icons.schedule,
                text: formatSchedule(event.startAt, event.endAt),
              ),
              const SizedBox(height: 4),
              _MetaRow(
                icon: Icons.place_outlined,
                text: event.location.address ?? 'Alamat belum tersedia',
              ),
              const SizedBox(height: 4),
              _MetaRow(
                icon: Icons.radio_button_unchecked,
                text: 'Radius ${formatMeters(event.location.radiusMeters)}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.event, required this.now});

  final Event event;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final bool ongoing = event.isOpenAt(now);
    final bool finished = now.isAfter(event.endAt);
    final String label = ongoing
        ? 'Berlangsung'
        : finished
        ? 'Selesai'
        : 'Belum Mulai';
    final Color accent = ongoing
        ? AppColors.success
        : finished
        ? AppColors.textSecondary
        : AppColors.warning;
    final Color background = ongoing
        ? AppColors.successTint
        : finished
        ? AppColors.background
        : AppColors.warningTint;

    return _Badge(label: label, background: background, foreground: accent);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
