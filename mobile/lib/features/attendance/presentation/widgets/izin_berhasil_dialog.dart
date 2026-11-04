import 'package:flutter/material.dart';

import 'izin_dialog.dart';

/// Kartu hasil contoh sesuai Figma, belum menandakan penyimpanan ke server.
class IzinBerhasilDialog extends StatelessWidget {
  const IzinBerhasilDialog({super.key});

  @override
  Widget build(BuildContext context) => IzinDialog(
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
          child: const Icon(Icons.location_on_rounded, color: _green, size: 36),
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Perizinan Terkirim!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF17212D),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      const Text(
        'Permohonan izin berhasil diajukan',
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
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: _green, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
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
  );
}

const _green = Color(0xFF24664E);
const _surface = Color(0xFFEEFBF5);
const _border = Color(0xFFC6E8D8);
