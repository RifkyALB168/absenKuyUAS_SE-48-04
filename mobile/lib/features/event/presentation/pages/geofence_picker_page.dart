import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'kegiatan.dart';
import '../widgets/geofence_map_preview.dart';

/// Halaman "Pilih Titik & Radius Geofence".
///
/// Semua nilai tetap: radius, alamat, dan koordinat diambil dari
/// [kegiatan.dart]. Belum ada state, geocoding, atau peta sungguhan;
/// lihat [GeofenceMapPreview].
class GeofencePickerPage extends StatelessWidget {
  const GeofencePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        toolbarHeight: 62,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
        ),
        titleSpacing: 0,
        title: const _SearchField(),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12, left: 8),
            child: _LocateButton(),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GeofenceMapPreview(
              radiusMeter: radiusMeter,
              centerLabel: 'Student Center',
            ),
          ),
          const _LocationSheet(),
        ],
      ),
    );
  }
}

/// Kotak pencarian lokasi di app bar.
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) => Container(
    height: 40,
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: const Row(
      children: <Widget>[
        Icon(Icons.search, size: 17, color: AppColors.textSecondary),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Gedung Student Center, Telkom',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
          ),
        ),
        Icon(Icons.close, size: 15, color: AppColors.textSecondary),
      ],
    ),
  );
}

/// Tombol bulat biru untuk "kembali ke lokasi saya".
class _LocateButton extends StatelessWidget {
  const _LocateButton();

  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 38,
    decoration: const BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.my_location,
      size: 19,
      color: AppColors.surface,
    ),
  );
}

/// Panel bawah: alamat hasil geocoding, koordinat, dan pemilih radius.
class _LocationSheet extends StatelessWidget {
  const _LocationSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0x140F172A), blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(child: _DragHandle()),
              const SizedBox(height: 12),
              const _AddressRow(),
              const SizedBox(height: 12),
              const _CoordinateRow(),
              const Divider(height: 26, color: AppColors.border),
              const _RadiusHeader(),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: AppColors.border,
                  thumbColor: AppColors.primary,
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: 0.12,
                  onChanged: (_) {},
                ),
              ),
              const _SliderScale(),
              const SizedBox(height: 12),
              const _RadiusChips(),
              const SizedBox(height: 18),
              const _PrimaryButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: AppColors.border,
      borderRadius: BorderRadius.circular(100),
    ),
  );
}

/// Baris alamat: ikon, label kecil, alamat, keterangan, dan badge HTTP.
class _AddressRow extends StatelessWidget {
  const _AddressRow();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.primaryTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.place, size: 18, color: AppColors.primary),
      ),
      const SizedBox(width: 10),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ALAMAT LOKASI (GOOGLE GEOCODING)',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 3),
            Text(
              alamatGeocoding,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Jika geocoding gagal, koordinat ditampilkan otomatis.',
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      const _HttpBadge(),
    ],
  );
}

/// Badge "HTTP 200 OK" hijau.
class _HttpBadge extends StatelessWidget {
  const _HttpBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.successTint,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
    ),
    child: const Column(
      children: <Widget>[
        Text(
          'HTTP 200',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        ),
        Text(
          'OK',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        ),
      ],
    ),
  );
}

/// Baris koordinat: Lat, Lng, dan tombol Salin.
class _CoordinateRow extends StatelessWidget {
  const _CoordinateRow();

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      const Expanded(child: _CoordinateField(label: 'Lat', value: koordinatLat)),
      const SizedBox(width: 10),
      const Expanded(child: _CoordinateField(label: 'Lng', value: koordinatLng)),
      const SizedBox(width: 6),
      TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, AppTheme.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: const Text(
          'Salin',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    ],
  );
}

class _CoordinateField extends StatelessWidget {
  const _CoordinateField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 42,
    decoration: BoxDecoration(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      border: Border.all(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: <Widget>[
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Judul bagian radius dan pil nilai radius.
class _RadiusHeader extends StatelessWidget {
  const _RadiusHeader();

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      const Icon(Icons.adjust, size: 16, color: AppColors.primary),
      const SizedBox(width: 6),
      const Expanded(
        child: Text(
          'Radius Area Presensi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          '$radiusMeter Meter',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.surface,
          ),
        ),
      ),
    ],
  );
}

/// Label skala slider: 30m (Min), 100m, 200m.
class _SliderScale extends StatelessWidget {
  const _SliderScale();

  static const TextStyle _style = TextStyle(
    fontSize: 10,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('30m (Min)', style: _style),
        Text('100m', style: _style),
        Text('200m', style: _style),
      ],
    ),
  );
}

/// Baris tombol radius: 30m, 50m (aktif), 100m, 150m.
class _RadiusChips extends StatelessWidget {
  const _RadiusChips();

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      for (final int meter in radiusPilihan) ...<Widget>[
        Expanded(
          child: _RadiusChip(
            meter: meter,
            active: meter == radiusMeter,
          ),
        ),
        if (meter != radiusPilihan.last) const SizedBox(width: 8),
      ],
    ],
  );
}

class _RadiusChip extends StatelessWidget {
  const _RadiusChip({required this.meter, required this.active});

  final int meter;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: active ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      border: Border.all(
        color: active ? AppColors.primary : AppColors.border,
        width: active ? 1.5 : 1,
      ),
    ),
    child: Text(
      '${meter}m',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: active ? AppColors.surface : AppColors.textPrimary,
      ),
    ),
  );
}

/// Tombol utama: "Gunakan Lokasi & Radius Ini".
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton();

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: AppTheme.minTouchTarget,
    child: FilledButton.icon(
      onPressed: () => Navigator.of(context).maybePop(),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.controlRadius),
        ),
      ),
      icon: const Icon(Icons.check_circle_outline, size: 18),
      label: const Text(
        'Gunakan Lokasi & Radius Ini',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
