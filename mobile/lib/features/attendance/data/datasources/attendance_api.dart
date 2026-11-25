import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/attendance_check.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceApi implements AttendanceRepository {
  AttendanceApi({
    required this.baseUrl,
    required this.accessToken,
    this.client,
  });

  final Uri baseUrl;
  final Future<String?> Function() accessToken;
  final http.Client? client;

  @override
  Future<void> submit({
    required AttendanceEvent event,
    required AttendancePosition position,
    required File photo,
    required String requestId,
  }) async {
    final token = await accessToken();
    if (token == null || token.trim().isEmpty) {
      throw const AttendanceSubmitFailure(
        'Sesi berakhir. Silakan masuk kembali.',
      );
    }
    if (baseUrl.scheme != 'https' || baseUrl.host.isEmpty || event.isDemo) {
      throw const AttendanceSubmitFailure('Koneksi presensi belum tersedia.');
    }

    final uri = Uri(
      scheme: baseUrl.scheme,
      host: baseUrl.host,
      port: baseUrl.hasPort ? baseUrl.port : null,
      pathSegments: [
        ...baseUrl.pathSegments.where((segment) => segment.isNotEmpty),
        'events',
        event.id,
        'attendances',
      ],
    );
    final request = http.MultipartRequest('POST', uri)
      ..followRedirects = false
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Idempotency-Key': requestId,
      })
      ..fields.addAll({
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'accuracy': position.accuracy.toString(),
        'is_mocked': position.isMocked.toString(),
      });

    try {
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
    } on FileSystemException {
      throw const AttendanceSubmitFailure(
        'File selfie sudah tidak tersedia. Silakan foto ulang.',
      );
    }

    final transport = client ?? http.Client();
    try {
      final response = await transport
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 30));
      final body = _decode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['status'] == 'hadir' &&
          body['id'] != null) {
        return;
      }
      throw _failure(response.statusCode, body, event);
    } on TimeoutException {
      throw const AttendanceSubmitFailure(
        'Server belum merespons. Coba lagi untuk memeriksa hasil kiriman.',
        retrySameRequest: true,
      );
    } on http.ClientException {
      throw const AttendanceSubmitFailure(
        'Koneksi terputus. Coba lagi untuk memeriksa hasil kiriman.',
        retrySameRequest: true,
      );
    } finally {
      if (client == null) transport.close();
    }
  }

  Map<String, dynamic> _decode(String response) {
    try {
      final data = jsonDecode(response);
      return data is Map<String, dynamic> ? data : {};
    } on FormatException {
      return {};
    }
  }

  AttendanceSubmitFailure _failure(
    int status,
    Map<String, dynamic> body,
    AttendanceEvent event,
  ) {
    final code = body['code'];
    final distance = body['distance_m'];
    final message = switch (code) {
      'WINDOW_CLOSED' => 'Jadwal presensi sudah tidak terbuka.',
      'MOCKED_LOCATION' => 'Presensi ditolak karena lokasi palsu terdeteksi.',
      'OUT_OF_RANGE' =>
        distance is num
            ? 'Jarak Anda ${distance.toStringAsFixed(1)} m. Radius kegiatan ${body['radius_m'] ?? event.radiusMeters} m.'
            : 'Lokasi Anda di luar radius kegiatan.',
      'INACCURATE_LOCATION' =>
        'Lokasi kurang akurat. Coba lagi di tempat yang lebih terbuka.',
      'ALREADY_ATTENDED' => 'Presensi untuk kegiatan ini sudah tercatat.',
      'INVALID_PHOTO' => 'Selfie tidak dapat diterima. Silakan foto ulang.',
      _ when status == 401 => 'Sesi berakhir. Silakan masuk kembali.',
      _ when status == 403 =>
        'Akun ini tidak memiliki akses presensi kegiatan.',
      _ when status == 404 => 'Kegiatan sudah tidak tersedia.',
      _ => 'Hasil presensi belum bisa dikonfirmasi. Silakan coba lagi.',
    };
    return AttendanceSubmitFailure(
      message,
      retrySameRequest: status >= 500 || status < 400,
    );
  }
}
