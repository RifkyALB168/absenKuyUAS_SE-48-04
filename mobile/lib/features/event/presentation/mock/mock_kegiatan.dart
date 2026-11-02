/// Data contoh untuk mockup UI M3 (manajemen kegiatan).
///
/// Mockup sengaja tidak punya fungsi apa pun: tidak ada repository, bloc,
/// atau pemanggilan jaringan. Semua nilai di bawah ini tetap (hardcoded)
/// supaya layar bisa dilihat tanpa backend.
class MockKegiatan {
  const MockKegiatan({
    required this.judul,
    required this.kelompok,
    required this.tanggal,
    required this.jam,
    required this.lokasi,
    required this.radiusMeter,
    required this.status,
    required this.hadir,
    required this.total,
  });

  final String judul;
  final String kelompok;
  final String tanggal;
  final String jam;
  final String lokasi;
  final int radiusMeter;
  final MockStatusKegiatan status;
  final int hadir;
  final int total;
}

/// Status kegiatan pada daftar M3.
enum MockStatusKegiatan { berlangsung, dijadwalkan, ditutup }

/// Tiga kegiatan contoh yang tampil di halaman daftar.
const List<MockKegiatan> mockKegiatan = <MockKegiatan>[
  MockKegiatan(
    judul: 'Rapat Pleno & Evaluasi Mingguan',
    kelompok: 'UKM Robotika',
    tanggal: '23 Okt 2026',
    jam: '14:00 – 16:00 WIB',
    lokasi: 'Gedung Tokong Nanas (TULT) Lt. 3',
    radiusMeter: 50,
    status: MockStatusKegiatan.berlangsung,
    hadir: 28,
    total: 32,
  ),
  MockKegiatan(
    judul: 'Weekly Riset & Development',
    kelompok: 'UKM CCI',
    tanggal: '24 Okt 2026',
    jam: '15:30 – 17:30 WIB',
    lokasi: 'Gedung Student Center, Jl. Telekomunikasi',
    radiusMeter: 50,
    status: MockStatusKegiatan.dijadwalkan,
    hadir: 0,
    total: 24,
  ),
  MockKegiatan(
    judul: 'Latihan Gabungan Antar Kampus',
    kelompok: 'UKM Basket',
    tanggal: '10 Okt 2026',
    jam: '16:20 WIB',
    lokasi: 'Lapangan Basket Kampus',
    radiusMeter: 100,
    status: MockStatusKegiatan.ditutup,
    hadir: 19,
    total: 26,
  ),
];

/// Nama kelompok untuk dropdown "Pilih Kelompok / Organisasi".
const List<String> mockKelompok = <String>[
  'UKM CCI',
  'UKM Robotika',
  'UKM Basket',
];

/// Teks contoh untuk isian panjang di form.
const String mockDeskripsiKegiatan =
    'Riset Pasar dan Analisis Kebutuhan: Mengamati tren industri, perilaku '
    'konsumen, serta menganalisis kelemahan produk kompetitor untuk mencari '
    'peluang baru.';

/// Nilai contoh untuk isian di form M3.
const String mockJudulKegiatan = 'Weekly Riset & Development';
const String mockTanggalKegiatan = 'Jumat, 24 Okt 2026';

/// Nilai contoh untuk layar M5 (pilih titik & radius geofence).
const String mockAlamatGeocoding =
    'Gedung Student Center, Jl. Telekomunikasi';
const String mockKoordinatLat = '-6.973210';
const String mockKoordinatLng = '107.638400';
const int mockRadiusMeter = 50;

/// Pilihan radius pada baris tombol 30m / 50m / 100m / 150m.
const List<int> mockRadiusPilihan = <int>[30, 50, 100, 150];
