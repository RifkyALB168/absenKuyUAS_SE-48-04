import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_config.dart';
import '../models/event_model.dart';
import 'remote_exception.dart';

/// Akses REST API kegiatan (M3) ke backend Node.js + Express.
///
/// Endpoint yang dipakai (lihat juga kolom Backend pada README):
/// - `GET    /events`                daftar semua kegiatan
/// - `GET    /groups/:id/events`     kegiatan satu kelompok
/// - `GET    /events/:id`            detail kegiatan
/// - `POST   /groups/:id/events`     membuat kegiatan
/// - `PUT    /events/:id`            mengubah kegiatan
/// - `DELETE /events/:id`            menghapus kegiatan
class EventRemoteDataSource {
  EventRemoteDataSource({http.Client? client, String? baseUrl, this.authToken})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _client;
  final String _baseUrl;

  /// Token JWT dari sesi login (S4). Bila null, header Authorization dilewatkan
  /// saja; backend yang menentukan apakah endpoint butuh login.
  final String? authToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  Future<List<EventModel>> fetchEvents({String? groupId}) async {
    final Uri uri = Uri.parse(
      '$_baseUrl/events',
    ).replace(queryParameters: groupId == null ? null : {'group_id': groupId});
    final http.Response response = await _get(uri);
    return _decodeList(response);
  }

  Future<List<EventModel>> fetchGroupEvents(String groupId) async {
    final http.Response response = await _get(
      Uri.parse('$_baseUrl/groups/$groupId/events'),
    );
    return _decodeList(response);
  }

  Future<EventModel> fetchEventById(String id) async {
    final http.Response response = await _get(
      Uri.parse('$_baseUrl/events/$id'),
    );
    return _decodeObject(response);
  }

  Future<EventModel> createEvent(EventModel event) async {
    final http.Response response = await _send(
      'POST',
      Uri.parse('$_baseUrl/groups/${event.groupId}/events'),
      event.toJson(),
      expectedStatus: 201,
    );
    return _decodeObject(response);
  }

  Future<EventModel> updateEvent(EventModel event) async {
    final http.Response response = await _send(
      'PUT',
      Uri.parse('$_baseUrl/events/${event.id}'),
      event.toJson(),
    );
    return _decodeObject(response);
  }

  Future<void> deleteEvent(String id) async {
    final http.Response response = await _send(
      'DELETE',
      Uri.parse('$_baseUrl/events/$id'),
      null,
    );
    if (response.statusCode >= 400) {
      throw EventRemoteException(
        'Gagal menghapus kegiatan',
        statusCode: response.statusCode,
      );
    }
  }

  Future<http.Response> _get(Uri uri) => _send('GET', uri, null);

  Future<http.Response> _send(
    String method,
    Uri uri,
    Object? body, {
    int expectedStatus = 200,
  }) async {
    try {
      final http.Response response = await switch (method) {
        'GET' => _client.get(uri, headers: _headers),
        'POST' => _client.post(uri, headers: _headers, body: jsonEncode(body)),
        'PUT' => _client.put(uri, headers: _headers, body: jsonEncode(body)),
        'DELETE' => _client.delete(uri, headers: _headers),
        _ => throw ArgumentError.value(
          method,
          'method',
          'Metode tidak dikenal',
        ),
      };

      if (response.statusCode != expectedStatus && response.statusCode >= 400) {
        throw EventRemoteException(
          'Permintaan $method ${uri.path} gagal',
          statusCode: response.statusCode,
        );
      }
      return response;
    } on EventRemoteException {
      rethrow;
    } on SocketException catch (error) {
      throw EventRemoteException(
        'Tidak dapat menghubungi server: ${error.message}',
      );
    } on TimeoutException {
      throw const EventRemoteException('Koneksi ke server habis waktu');
    } on http.ClientException catch (error) {
      throw EventRemoteException('Koneksi ke server gagal: ${error.message}');
    }
  }

  List<EventModel> _decodeList(http.Response response) {
    final Object? decoded = _decodeBody(response);
    final List<dynamic> items = switch (decoded) {
      List<dynamic> list => list,
      Map<String, dynamic> map when map['data'] is List =>
        map['data']! as List<dynamic>,
      _ => throw const EventRemoteException(
        'Format daftar kegiatan tidak dikenal',
      ),
    };
    return items
        .cast<Map<String, dynamic>>()
        .map(EventModel.fromJson)
        .toList(growable: false);
  }

  EventModel _decodeObject(http.Response response) {
    final Object? decoded = _decodeBody(response);
    final Map<String, dynamic> json = switch (decoded) {
      Map<String, dynamic> map when map['data'] is Map =>
        (map['data']! as Map).cast<String, dynamic>(),
      Map<String, dynamic> map => map,
      _ => throw const EventRemoteException('Format kegiatan tidak dikenal'),
    };
    return EventModel.fromJson(json);
  }

  Object? _decodeBody(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw const EventRemoteException('Respons server bukan JSON');
    }
  }
}
