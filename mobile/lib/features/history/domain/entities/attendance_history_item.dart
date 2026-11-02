import 'package:flutter/material.dart';

/// icon kartu.
enum ThumbnailType { selfie, document, alert }

/// Model data riwayat kehadiran.
class AttendanceHistoryItem {
  final String title;
  final String date;
  final String subtitle;
  final String badgeText;
  final Color badgeTextColor;
  final Color badgeBackgroundColor;
  final ThumbnailType thumbnailType;
  final String? organization;
  final String? actionLink;
  final Color? borderColor;

  const AttendanceHistoryItem({
    required this.title,
    required this.date,
    required this.subtitle,
    required this.badgeText,
    required this.badgeTextColor,
    required this.badgeBackgroundColor,
    required this.thumbnailType,
    this.organization,
    this.actionLink,
    this.borderColor,
  });
}

/// Dummy data kartu riwayat kehadiran
const List<AttendanceHistoryItem> dummyHistoryItems = [
  AttendanceHistoryItem(
    organization: 'UKM Robotika',
    title: 'Rapat Pleno UKM Robotika',
    date: '23 Okt 2026, 14:04 WIB',
    subtitle: 'Jarak: 18m (Radius 50m)',
    badgeText: 'Hadir',
    badgeTextColor: Color(0xFF065F46),
    badgeBackgroundColor: Color(0xFFECFDF5),
    thumbnailType: ThumbnailType.selfie,
    actionLink: 'Lihat foto selfie & peta lokasi',
  ),
  AttendanceHistoryItem(
    organization: 'Himpunan Mahasiswa (HIMA-SE)',
    title: 'Bakti Sosial Himpunan',
    date: '18 Okt 2026, 08:30 WIB',
    subtitle: 'Izin Sakit • Bukti foto terlampir',
    badgeText: 'Izin Disetujui',
    badgeTextColor: Color(0xFF92400E),
    badgeBackgroundColor: Color(0xFFFFFBEB),
    thumbnailType: ThumbnailType.document,
  ),
  AttendanceHistoryItem(
    organization: 'UKM Basket',
    title: 'Latihan Gabungan',
    date: '10 Okt 2026, 16:20 WIB',
    subtitle: 'Ditolak: Di luar radius (Jarak 142m dari batas 50m)',
    badgeText: 'Ditolak',
    badgeTextColor: Color(0xFF9F1239),
    badgeBackgroundColor: Color(0xFFFFF1F2),
    thumbnailType: ThumbnailType.alert,
    actionLink: 'Lihat Pelanggaran radius',
    borderColor: Color(0xFFFECDD3),
  ),
  AttendanceHistoryItem(
    organization: 'UKM Robotika',
    title: 'Workshop IoT & Mikrokontroler',
    date: '07 Okt 2026, 13:15 WIB',
    subtitle: 'Jarak: 24m (Batas 40m TULT Lt.2)',
    badgeText: 'Hadir',
    badgeTextColor: Color(0xFF065F46),
    badgeBackgroundColor: Color(0xFFECFDF5),
    thumbnailType: ThumbnailType.selfie,
    actionLink: 'Lihat foto selfie & peta lokasi',
  ),
];
