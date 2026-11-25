import 'package:intl/intl.dart';

import '../../../attendance/domain/attendance_check.dart';

/// Data kegiatan untuk layar M3 (manajemen kegiatan).
///
/// Nilai di bawah ini tetap dan tidak lewat repository, bloc, atau jaringan,
/// supaya layar bisa dilihat tanpa backend.
class Kegiatan {
  const Kegiatan({
    required this.judul,
    required this.kelompok,
    required this.tanggal,
    required this.jam,
    required this.lokasi,
    required this.radiusMeter,
    required this.status,
    required this.hadir,
    required this.total,
    this.presensi,
  });

  final String judul;
  final String kelompok;
  final String tanggal;
  final String jam;
  final String lokasi;
  final int radiusMeter;
  final StatusKegiatan status;
  final int hadir;
  final int total;
  final AttendanceEvent? presensi;
}

/// Status kegiatan pada daftar M3.
enum StatusKegiatan { berlangsung, dijadwalkan, ditutup }

// Jendela kegiatan demo dimulai saat aplikasi memuat daftar contoh.
final _waktuContoh = DateTime.now();
final _bukaContoh = _waktuContoh.subtract(const Duration(hours: 1));
final _tutupContoh = _waktuContoh.add(const Duration(hours: 1));

/// Tiga kegiatan yang tampil di halaman daftar.
final List<Kegiatan> daftarKegiatan = <Kegiatan>[
  Kegiatan(
    judul: 'Rapat Pleno & Evaluasi Mingguan',
    kelompok: 'UKM Robotika',
    tanggal: DateFormat('dd/MM/yyyy').format(_waktuContoh),
    jam:
        '${DateFormat('HH:mm').format(_bukaContoh)} – '
        '${DateFormat('HH:mm').format(_tutupContoh)}',
    lokasi: 'Titik contoh kampus',
    radiusMeter: 50,
    status: StatusKegiatan.berlangsung,
    hadir: 28,
    total: 32,
    presensi: AttendanceEvent(
      id: 'demo-pleno',
      latitude: -6.973210,
      longitude: 107.638400,
      radiusMeters: 50,
      opensAt: _bukaContoh.toUtc(),
      closesAt: _tutupContoh.toUtc(),
      isDemo: true,
    ),
  ),
  const Kegiatan(
    judul: 'Weekly Riset & Development',
    kelompok: 'UKM CCI',
    tanggal: '24 Okt 2026',
    jam: '15:30 – 17:30 WIB',
    lokasi: 'Gedung Student Center, Jl. Telekomunikasi',
    radiusMeter: 50,
    status: StatusKegiatan.dijadwalkan,
    hadir: 0,
    total: 24,
  ),
  const Kegiatan(
    judul: 'Latihan Gabungan Antar Kampus',
    kelompok: 'UKM Basket',
    tanggal: '10 Okt 2026',
    jam: '16:20 WIB',
    lokasi: 'Lapangan Basket Kampus',
    radiusMeter: 100,
    status: StatusKegiatan.ditutup,
    hadir: 19,
    total: 26,
  ),
];

/// Isi awal untuk isian panjang di form.
const String deskripsiKegiatan =
    'Riset Pasar dan Analisis Kebutuhan: Mengamati tren industri, perilaku '
    'konsumen, serta menganalisis kelemahan produk kompetitor untuk mencari '
    'peluang baru.';

/// Isi awal untuk isian di form M3.
const String judulKegiatan = 'Weekly Riset & Development';
const String tanggalKegiatan = 'Jumat, 24 Okt 2026';

/// Isi awal untuk layar pilih titik & radius geofence.
const String alamatGeocoding = 'Gedung Student Center, Jl. Telekomunikasi';
const String koordinatLat = '-6.973210';
const String koordinatLng = '107.638400';
const int radiusMeter = 50;

/// Pilihan radius pada baris tombol 30m / 50m / 100m / 150m.
const List<int> radiusPilihan = <int>[30, 50, 100, 150];
