import 'package:equatable/equatable.dart';

import '../../../../core/utils/geo.dart';

/// Siklus hidup kegiatan (M3).
enum EventStatus {
  /// Baru dibuat penyelenggara, belum tampil untuk anggota.
  draft,

  /// Sudah dibuka, anggota dapat melihat dan melakukan presensi.
  published,

  /// Selesai atau dibatalkan, presensi ditutup.
  closed;

  /// Membaca status dari nilai yang dikirim backend.
  ///
  /// Nilai `null` atau yang tidak dikenal diperlakukan sebagai [draft], supaya
  /// data lama tidak membuat aplikasi gagal parse.
  static EventStatus fromName(String? value) {
    for (final EventStatus status in EventStatus.values) {
      if (status.name == value) return status;
    }
    return EventStatus.draft;
  }
}

/// Lokasi pelaksanaan kegiatan: titik presensi, radius geofence, dan alamat
/// (M3 memilih lokasi di peta & alamat otomatis, M5 marker + radius).
class EventLocation extends Equatable {
  const EventLocation({
    required this.point,
    this.radiusMeters = defaultRadiusMeters,
    this.address,
    this.placeName,
  });

  /// Radius geofence default dalam meter bila penyelenggara tidak mengubahnya.
  static const double defaultRadiusMeters = 100;

  /// Titik presensi kegiatan.
  final GeoPoint point;

  /// Radius toleransi kehadiran di sekitar [point], dalam meter.
  final double radiusMeters;

  /// Alamat lengkap hasil reverse geocoding ("alamat otomatis" M3).
  final String? address;

  /// Nama tempat singkat, mis. "Gedung TULT Telkom University".
  final String? placeName;

  /// Benar jika [candidate] masih berada di dalam radius kegiatan (M5).
  bool contains(GeoPoint candidate) => point.isWithin(candidate, radiusMeters);

  EventLocation copyWith({
    GeoPoint? point,
    double? radiusMeters,
    String? address,
    String? placeName,
  }) {
    return EventLocation(
      point: point ?? this.point,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      address: address ?? this.address,
      placeName: placeName ?? this.placeName,
    );
  }

  @override
  List<Object?> get props => [point, radiusMeters, address, placeName];
}

/// Kegiatan (event) milik sebuah kelompok atau UKM (M3).
///
/// Ini model murni domain: tidak menyimpan detail transportasi data. Konversi
/// ke/dari JSON dikerjakan oleh `EventModel` di layer data.
class Event extends Equatable {
  const Event({
    required this.id,
    required this.groupId,
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
    this.description = '',
    this.status = EventStatus.draft,
    this.createdBy,
    this.createdAt,
  });

  /// Identitas kegiatan dari backend. Kosong untuk kegiatan yang belum dibuat.
  final String id;

  /// Kelompok/UKM pemilik kegiatan.
  final String groupId;

  /// Judul kegiatan.
  final String title;

  /// Deskripsi atau catatan tambahan.
  final String description;

  /// Lokasi, radius, dan alamat kegiatan.
  final EventLocation location;

  /// Waktu kegiatan dimulai.
  final DateTime startAt;

  /// Waktu kegiatan berakhir.
  final DateTime endAt;

  /// Status kegiatan.
  final EventStatus status;

  /// Anggota yang membuat kegiatan.
  final String? createdBy;

  /// Waktu kegiatan dibuat di backend.
  final DateTime? createdAt;

  /// Benar jika [candidate] berada di dalam geofence kegiatan (M5).
  bool isWithinGeofence(GeoPoint candidate) => location.contains(candidate);

  /// Benar jika kegiatan sedang berlangsung pada [moment].
  ///
  /// Batas awal dan akhir dihitung inklusif.
  bool isOpenAt(DateTime moment) =>
      !moment.isBefore(startAt) && !moment.isAfter(endAt);

  /// Lama kegiatan berlangsung.
  Duration get duration => endAt.difference(startAt);

  Event copyWith({
    String? id,
    String? groupId,
    String? title,
    String? description,
    EventLocation? location,
    DateTime? startAt,
    DateTime? endAt,
    EventStatus? status,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    groupId,
    title,
    description,
    location,
    startAt,
    endAt,
    status,
    createdBy,
    createdAt,
  ];
}
