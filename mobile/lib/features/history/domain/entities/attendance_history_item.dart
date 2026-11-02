/// Tipe ikon/status kartu riwayat kehadiran.
enum ThumbnailType { selfie, document, alert }

/// Data detail kegiatan & presensi.
class AttendanceDetailData {
  final String title;
  final String date;
  final String location;

  const AttendanceDetailData({
    required this.title,
    required this.date,
    required this.location,
  });
}

/// Model data riwayat kehadiran.
class AttendanceHistoryItem {
  final String title;
  final String date;
  final String subtitle;
  final String badgeText;
  final ThumbnailType thumbnailType;
  final String? organization;
  final String? actionLink;
  final AttendanceDetailData? detailData;

  const AttendanceHistoryItem({
    required this.title,
    required this.date,
    required this.subtitle,
    required this.badgeText,
    required this.thumbnailType,
    this.organization,
    this.actionLink,
    this.detailData,
  });
}

/// Dummy data kartu riwayat kehadiran.
const List<AttendanceHistoryItem> dummyHistoryItems = [
  AttendanceHistoryItem(
    organization: 'UKM Robotika',
    title: 'Rapat Pleno UKM Robotika',
    date: '23 Okt 2026, 14:04 WIB',
    subtitle: 'Jarak: 18m (Radius 50m)',
    badgeText: 'Hadir',
    thumbnailType: ThumbnailType.selfie,
    actionLink: 'Lihat foto selfie & peta lokasi',
    detailData: AttendanceDetailData(
      title: 'Rapat Pleno & Evaluasi Mingguan',
      date: 'Jumat, 24 Oktober 2026 • 15:30 - 17:30 WIB',
      location: 'Gedung Tokong Nanas (TULT) Lt. 3',
    ),
  ),
  AttendanceHistoryItem(
    organization: 'Himpunan Mahasiswa (HIMA-SE)',
    title: 'Bakti Sosial Himpunan',
    date: '18 Okt 2026, 08:30 WIB',
    subtitle: 'Izin Sakit • Bukti foto terlampir',
    badgeText: 'Izin Disetujui',
    thumbnailType: ThumbnailType.document,
  ),
  AttendanceHistoryItem(
    organization: 'UKM Basket',
    title: 'Latihan Gabungan',
    date: '10 Okt 2026, 16:20 WIB',
    subtitle: 'Ditolak: Di luar radius (Jarak 142m dari batas 50m)',
    badgeText: 'Ditolak',
    thumbnailType: ThumbnailType.alert,
    actionLink: 'Lihat Pelanggaran radius',
  ),
  AttendanceHistoryItem(
    organization: 'UKM Robotika',
    title: 'Workshop IoT & Mikrokontroler',
    date: '07 Okt 2026, 13:15 WIB',
    subtitle: 'Jarak: 24m (Batas 40m TULT Lt.2)',
    badgeText: 'Hadir',
    thumbnailType: ThumbnailType.selfie,
    actionLink: 'Lihat foto selfie & peta lokasi',
  ),
];
