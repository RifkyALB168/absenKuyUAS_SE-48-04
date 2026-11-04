import 'package:flutter/material.dart';

import 'presensi_ditolak_dialog.dart';

/// Pratinjau penolakan S2; belum memeriksa isMocked atau aplikasi lokasi palsu.
class PresensiFakeGpsDialog extends StatelessWidget {
  const PresensiFakeGpsDialog({super.key});

  @override
  Widget build(BuildContext context) => const PresensiDitolakDialog(
    title: 'Lokasi Palsu Terdeteksi',
    subtitle: 'Presensi ditolak karena terdeteksi menggunakan lokasi palsu',
    code: 'MOCKED_LOCATION',
    description:
        'Sistem mendeteksi lokasi tiruan aktif. '
        'Nonaktifkan lokasi tiruan dan gunakan GPS perangkat, lalu coba ulang.',
  );
}
