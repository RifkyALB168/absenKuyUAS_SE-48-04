import 'package:flutter/material.dart';

/// Kartu hasil contoh sesuai Figma, belum menandakan penyimpanan ke server.
class PresensiBerhasilDialog extends StatelessWidget {
  const PresensiBerhasilDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 358),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: _border),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: _green,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Presensi Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF17212D),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Presensi tercatat, selamat beraktivitas',
              textAlign: TextAlign.center,
              style: TextStyle(color: _green, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: _green,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD0E9DC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Berhasil',
                                style: TextStyle(
                                  color: _green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Sistem Berhasil Menyimpan Data Presensi',
                              style: TextStyle(
                                color: Color(0xFF17212D),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: _border, height: 1),
                  ),
                  const Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.update_rounded,
                            size: 16,
                            color: Color(0xFF596574),
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Waktu Percobaan',
                              style: TextStyle(
                                color: Color(0xFF596574),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '24 Okt 2026, 15:40:12 WIB',
                        style: TextStyle(
                          color: Color(0xFF17212D),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    ),
  );
}

const _green = Color(0xFF24664E);
const _surface = Color(0xFFEEFBF5);
const _border = Color(0xFFC6E8D8);
