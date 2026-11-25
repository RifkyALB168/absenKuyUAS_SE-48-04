import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/datasources/attendance_location.dart';
import '../../domain/attendance_check.dart';
import 'presensi_ditolak_dialog.dart';

String attendanceWindow(AttendanceEvent event) {
  final format = DateFormat('dd/MM/yyyy HH:mm');
  return '${format.format(event.opensAt.toLocal())} – '
      '${format.format(event.closesAt.toLocal())} (waktu perangkat)';
}

(String, String) attendanceIssueText(
  AttendanceEvent event,
  AttendanceBlocked failure,
) => switch (failure.issue) {
  AttendanceIssue.eventUnavailable => (
    'Data presensi belum tersedia',
    'Hubungi pengurus UKM untuk memastikan jadwal dan titik presensi kegiatan.',
  ),
  AttendanceIssue.windowClosed => (
    'Di luar jadwal presensi',
    'Jadwal presensi ${attendanceWindow(event)}.',
  ),
  AttendanceIssue.gpsDisabled => (
    'Layanan lokasi mati',
    'Aktifkan lokasi perangkat, lalu tekan Hadir kembali.',
  ),
  AttendanceIssue.permissionDenied => (
    'Izin lokasi diperlukan',
    'Izinkan absenKuy membaca lokasi saat presensi, lalu coba lagi.',
  ),
  AttendanceIssue.permissionDeniedForever => (
    'Izin lokasi diblokir',
    'Buka pengaturan aplikasi dan izinkan akses lokasi presisi saat digunakan.',
  ),
  AttendanceIssue.inaccurateLocation => (
    'Lokasi kurang akurat',
    'Aktifkan lokasi presisi atau pindah ke tempat yang lebih terbuka, lalu coba lagi.',
  ),
  AttendanceIssue.locationUnavailable => (
    'Lokasi belum ditemukan',
    'Tunggu beberapa saat di tempat dengan sinyal GPS yang baik, lalu coba lagi.',
  ),
  AttendanceIssue.mockedLocation => (
    'Lokasi Palsu Terdeteksi',
    'Nonaktifkan lokasi tiruan sebelum melakukan presensi.',
  ),
  AttendanceIssue.outOfRange => (
    'Lokasi Di Luar Radius',
    'Jarak Anda ${failure.distance?.toStringAsFixed(1) ?? '–'} m. '
        'Radius kegiatan ${event.radiusMeters} m.',
  ),
};

Future<void> showAttendanceIssue(
  BuildContext context,
  AttendanceEvent event,
  AttendanceBlocked failure,
) {
  final (title, detail) = attendanceIssueText(event, failure);
  const location = AttendanceLocation();
  final openSettings = switch (failure.issue) {
    AttendanceIssue.gpsDisabled => location.openLocationSettings,
    AttendanceIssue.permissionDeniedForever ||
    AttendanceIssue.inaccurateLocation => location.openAppSettings,
    _ => null,
  };
  return showDialog<void>(
    context: context,
    builder: (_) => PresensiDitolakDialog(
      title: title,
      subtitle: detail,
      settings: openSettings,
    ),
  );
}
