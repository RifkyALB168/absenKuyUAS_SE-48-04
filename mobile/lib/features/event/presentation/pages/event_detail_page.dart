import 'package:flutter/material.dart';

import '../../../attendance/data/datasources/attendance_location.dart';
import '../../../attendance/domain/attendance_check.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../attendance/presentation/pages/presensi_selfie_page.dart';
import '../../../attendance/presentation/widgets/ajukan_izin_bottom_sheet.dart';
import '../../../attendance/presentation/widgets/attendance_issue_dialog.dart';
import 'kegiatan.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({
    super.key,
    required this.kegiatan,
    this.attendanceRepository,
    this.locate,
  });

  final Kegiatan kegiatan;
  final AttendanceRepository? attendanceRepository;
  final Future<AttendancePosition> Function()? locate;

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _checking = false;

  Future<void> _attend(AttendanceEvent event) async {
    if (_checking) return;
    setState(() => _checking = true);
    final locate = widget.locate ?? const AttendanceLocation().read;
    try {
      final check = await AttendanceCheck.run(event, locate);
      if (!mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => PresensiSelfiePage(
            event: event,
            check: check,
            locate: locate,
            attendanceRepository: widget.attendanceRepository,
          ),
        ),
      );
    } on AttendanceBlocked catch (error) {
      if (mounted) await showAttendanceIssue(context, event, error);
    } catch (_) {
      if (mounted) {
        await showAttendanceIssue(
          context,
          event,
          const AttendanceBlocked(AttendanceIssue.locationUnavailable),
        );
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kegiatan = widget.kegiatan;
    final event = kegiatan.presensi;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kegiatan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(kegiatan.judul, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(kegiatan.kelompok),
            const SizedBox(height: 16),
            Text(kegiatan.lokasi),
            const SizedBox(height: 8),
            if (event == null) ...[
              Text('${kegiatan.tanggal} · ${kegiatan.jam}'),
              const SizedBox(height: 8),
              const Text('Jadwal dan titik presensi belum tersedia.'),
            ] else ...[
              Text('Radius presensi ${event.radiusMeters} m'),
              Text('Jadwal presensi ${attendanceWindow(event)}'),
              if (event.isDemo) ...[
                const SizedBox(height: 8),
                const Text('Kegiatan demo. Hasil presensi tidak dikirim.'),
              ],
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: event == null || _checking
                  ? null
                  : () => _attend(event),
              icon: const Icon(Icons.how_to_reg_outlined),
              label: Text(_checking ? 'Memeriksa lokasi…' : 'Hadir'),
            ),
            if (event != null)
              OutlinedButton.icon(
                onPressed: _checking
                    ? null
                    : () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const AjukanIzinBottomSheet(),
                      ),
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Ajukan Izin / Sakit'),
              ),
          ],
        ),
      ),
    );
  }
}
