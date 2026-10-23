import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_config.dart';
import '../../../../core/utils/geo.dart';
import 'remote_exception.dart';

/// Reverse geocoding: koordinat -> alamat (M3, "alamat otomatis").
///
/// Memakai Google Geocoding API. Kunci API diisi saat menjalankan aplikasi,
/// tidak ditulis di kode:
///
/// ```
/// flutter run --dart-define=GEOCODING_API_KEY=xxxxxxxx
/// ```
class GeocodingRemoteDataSource {
  GeocodingRemoteDataSource({
    http.Client? client,
    String? apiKey,
    String? baseUrl,
    this.language = 'id',
  }) : _client = client ?? http.Client(),
       _apiKey = apiKey ?? ApiConfig.geocodingApiKey,
       _baseUrl = baseUrl ?? ApiConfig.geocodingBaseUrl;

  final http.Client _client;
  final String _apiKey;
  final String _baseUrl;

  /// Bahasa alamat hasil, "id" supaya sesuai konteks pemakaian di Indonesia.
  final String language;

  /// Alamat lengkap untuk [point], mis. "Jl. Telekomunikasi No.1, Bandung".
  Future<String> reverseGeocode(GeoPoint point) async {
    if (_apiKey.isEmpty) {
      throw const EventRemoteException(
        'GEOCODING_API_KEY belum diisi, alamat otomatis tidak aktif',
      );
    }

    final Uri uri = Uri.parse('$_baseUrl/geocode/json').replace(
      queryParameters: {
        'latlng': '${point.latitude},${point.longitude}',
        'key': _apiKey,
        'language': language,
      },
    );

    try {
      final http.Response response = await _client.get(
        uri,
        headers: const {'Accept': 'application/json'},
      );

      if (response.statusCode >= 400) {
        throw EventRemoteException(
          'Permintaan geocoding gagal',
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> json = (jsonDecode(response.body) as Map)
          .cast<String, dynamic>();
      final String status = json['status'] as String? ?? '';

      if (status != 'OK') {
        throw EventRemoteException('Geocoding gagal: $status');
      }

      final List<dynamic> results =
          (json['results'] as List?) ?? const <dynamic>[];
      if (results.isEmpty) {
        throw const EventRemoteException('Alamat tidak ditemukan');
      }

      final Map<String, dynamic> first = (results.first as Map)
          .cast<String, dynamic>();
      return first['formatted_address'] as String? ?? '';
    } on EventRemoteException {
      rethrow;
    } on SocketException catch (error) {
      throw EventRemoteException(
        'Tidak dapat menghubungi server: ${error.message}',
      );
    } on TimeoutException {
      throw const EventRemoteException('Koneksi ke server habis waktu');
    } on FormatException {
      throw const EventRemoteException('Respons geocoding bukan JSON');
    } on http.ClientException catch (error) {
      throw EventRemoteException('Koneksi ke server gagal: ${error.message}');
    }
  }
}
