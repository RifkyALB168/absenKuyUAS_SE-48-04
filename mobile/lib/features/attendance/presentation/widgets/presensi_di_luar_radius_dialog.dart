import 'package:flutter/material.dart';

import 'presensi_ditolak_dialog.dart';

/// Pratinjau penolakan M4.3 sesuai revisi tampilan.
class PresensiDiLuarRadiusDialog extends StatelessWidget {
  const PresensiDiLuarRadiusDialog({super.key});

  @override
  Widget build(BuildContext context) => const PresensiDitolakDialog(
    title: 'Lokasi Di Luar Radius',
    subtitle: 'Presensi ditolak karena lokasi di luar jangkauan',
  );
}
