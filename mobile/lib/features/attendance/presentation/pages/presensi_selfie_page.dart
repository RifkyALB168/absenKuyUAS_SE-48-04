import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/selfie_camera.dart';
import '../../domain/attendance_check.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/selfie_repository.dart';
import '../bloc/selfie_cubit.dart';
import '../bloc/selfie_state.dart';
import '../widgets/attendance_issue_dialog.dart';
import '../widgets/presensi_berhasil_dialog.dart';

class PresensiSelfiePage extends StatelessWidget {
  const PresensiSelfiePage({
    super.key,
    required this.event,
    required this.check,
    required this.locate,
    this.attendanceRepository,
    this.camera,
  });

  final AttendanceEvent event;
  final AttendanceCheck check;
  final Future<AttendancePosition> Function() locate;
  final AttendanceRepository? attendanceRepository;
  final SelfieRepository? camera;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => SelfieCubit(camera ?? SelfieCamera())..recoverPhoto(),
    child: BlocConsumer<SelfieCubit, SelfieState>(
      listener: (context, state) async {
        if (state.issue case final issue?) {
          await showAttendanceIssue(context, event, issue);
          return;
        }
        if (state.submitted) {
          await showDialog<void>(
            context: context,
            builder: (_) => const PresensiBerhasilDialog(),
          );
          if (context.mounted) Navigator.of(context).maybePop();
          return;
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) => PopScope(
        canPop: !state.isSubmitting,
        child: _buildPage(context, state),
      ),
    ),
  );

  Widget _buildPage(BuildContext context, SelfieState state) {
    final repository = attendanceRepository;
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Tutup presensi',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Kamera Presensi Selfie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Bantuan presensi',
            icon: const Icon(Icons.help_outline_rounded, size: 22),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Panduan foto selfie'),
                content: const Text(
                  'Posisikan wajah di tengah kamera dan pastikan pencahayaan cukup.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Mengerti'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  _CameraPreview(photo: state.photo, isBusy: state.isBusy),
                  _ValidationCard(event: event, check: check),
                  _PhotoControls(
                    state: state,
                    onSubmit: repository == null || event.isDemo
                        ? null
                        : () => context.read<SelfieCubit>().submit(
                            event: event,
                            locate: locate,
                            repository: repository,
                          ),
                    unavailableMessage: event.isDemo
                        ? 'Kegiatan demo. Selfie hanya digunakan untuk pratinjau.'
                        : 'Pengiriman presensi belum tersedia.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  const _CameraPreview({required this.photo, required this.isBusy});

  final File? photo;
  final bool isBusy;

  @override
  Widget build(BuildContext context) => Semantics(
    label: photo == null ? 'Pratinjau kamera' : 'Hasil foto selfie',
    child: AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFF25313D),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (photo != null)
              Image.file(
                photo!,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Center(
                  child: Text(
                    'Foto tidak dapat ditampilkan. Silakan foto ulang.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF17212D),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Text(
                  photo == null
                      ? 'Posisikan wajah Anda di tengah kamera'
                      : 'Pastikan wajah terlihat jelas sebelum melanjutkan',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
            if (isBusy)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    ),
  );
}

class _ValidationCard extends StatelessWidget {
  const _ValidationCard({required this.event, required this.check});

  final AttendanceEvent event;
  final AttendanceCheck check;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PEMERIKSAAN AWAL DI PERANGKAT',
            style: TextStyle(color: _muted, fontSize: 10, letterSpacing: 0.4),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(
                child: _ValidationItem(
                  icon: Icons.verified_outlined,
                  title: 'Jarak ke kegiatan',
                  subtitle:
                      '${check.distance.toStringAsFixed(1)} m / ${event.radiusMeters} m',
                ),
              ),
              Expanded(
                child: _ValidationItem(
                  icon: Icons.my_location,
                  title: 'Akurasi GPS',
                  subtitle: '±${check.position.accuracy.toStringAsFixed(1)} m',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValidationItem extends StatelessWidget {
  const _ValidationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFECFDF5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      spacing: 4,
      children: [
        Icon(icon, size: 18, color: _green),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _green,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: _green, fontSize: 10),
        ),
      ],
    ),
  );
}

class _PhotoControls extends StatelessWidget {
  const _PhotoControls({
    required this.state,
    required this.onSubmit,
    required this.unavailableMessage,
  });

  final SelfieState state;
  final VoidCallback? onSubmit;
  final String unavailableMessage;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    tooltip: 'Foto ulang',
                    onPressed:
                        state.photo == null ||
                            state.isBusy ||
                            state.retrying ||
                            state.submitted
                        ? null
                        : () => context.read<SelfieCubit>().takePhoto(),
                    icon: const Icon(Icons.restart_alt_rounded),
                  ),
                  const Text(
                    'Foto Ulang',
                    style: TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC7D2FE), width: 2),
              ),
              child: IconButton.filled(
                tooltip: 'Ambil foto',
                style: IconButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(56, 56),
                ),
                onPressed: state.isBusy || state.retrying || state.submitted
                    ? null
                    : () => context.read<SelfieCubit>().takePhoto(),
                icon: const Icon(Icons.photo_camera_outlined, size: 28),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: state.photo == null || state.isBusy || state.submitted
              ? null
              : onSubmit,
          child: Text(
            state.isSubmitting
                ? 'Mengirim presensi…'
                : state.retrying
                ? 'Coba Kirim Lagi'
                : 'Kirim Presensi Sekarang',
          ),
        ),
        if (onSubmit == null) ...[
          const SizedBox(height: 8),
          Text(
            unavailableMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
        ],
      ],
    ),
  );
}

const _background = Color(0xFFF7F9FB);
const _ink = Color(0xFF17212D);
const _muted = Color(0xFF596574);
const _blue = Color(0xFF365CE6);
const _green = Color(0xFF24664E);
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: const Color(0xFFE0E3E5)),
);
