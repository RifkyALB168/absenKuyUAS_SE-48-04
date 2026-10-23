import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../bloc/event_address_bloc.dart';
import '../bloc/event_address_event.dart';
import '../bloc/event_address_state.dart';
import '../event_formatters.dart';
import '../widgets/geofence_map_preview.dart';

/// Form tambah/ubah kegiatan dengan pin peta, alamat otomatis, dan radius
/// (M3.1, M3.2, M3.5, M3.6).
///
/// Mengembalikan [Event] lewat `Navigator.pop`; penyimpanan ke repositori
/// dilakukan oleh [EventListBloc] agar hanya ada satu jalur tulis.
class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key, required this.repository, this.event});

  final EventRepository repository;

  /// Bila diisi, form menjadi mode ubah.
  final Event? event;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  /// Daftar kelompok sementara. Diganti data M2 (Khalifa) setelah siap.
  static const List<MapEntry<String, String>> _groups =
      <MapEntry<String, String>>[
        MapEntry<String, String>('1', 'UKM Robotika'),
        MapEntry<String, String>('2', 'BEM Fakultas'),
        MapEntry<String, String>('3', 'Panitia PKKMB'),
      ];

  /// Radius minimum menurut M3.5.
  static const double _minRadius = 30;
  static const double _maxRadius = 500;

  late final TextEditingController _title;
  late final TextEditingController _description;
  late String _groupId;
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late double _radius;
  late GeoPoint _point;
  String? _address;

  String? _titleError;
  String? _timeError;
  String? _radiusError;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    final Event? existing = widget.event;
    _title = TextEditingController(text: existing?.title ?? '');
    _description = TextEditingController(text: existing?.description ?? '');
    _groupId = existing?.groupId ?? _groups.first.key;
    final DateTime startAt = existing?.startAt ?? _defaultStart();
    _date = DateTime(startAt.year, startAt.month, startAt.day);
    _startTime = TimeOfDay.fromDateTime(startAt);
    _endTime = TimeOfDay.fromDateTime(
      existing?.endAt ?? startAt.add(const Duration(hours: 2)),
    );
    _radius = (existing?.location.radiusMeters ?? 50).clamp(
      _minRadius,
      _maxRadius,
    );
    _point = existing?.location.point ?? const GeoPoint(-6.9732, 107.6304);
    _address = existing?.location.address;
  }

  static DateTime _defaultStart() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 9);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventAddressBloc>(
      create: (_) => EventAddressBloc(widget.repository),
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_isEditing ? 'Ubah Kegiatan' : 'Buat Kegiatan Baru'),
            ),
            body: BlocListener<EventAddressBloc, EventAddressState>(
              listener: (BuildContext context, EventAddressState state) {
                if (state.status == EventAddressStatus.success) {
                  setState(() => _address = state.address);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.gap),
                children: <Widget>[
                  _Section(
                    title: 'Informasi Kegiatan',
                    child: Column(
                      children: <Widget>[
                        _GroupDropdown(
                          value: _groupId,
                          groups: _groups,
                          onChanged: (String value) =>
                              setState(() => _groupId = value),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _title,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Judul Kegiatan',
                            errorText: _titleError,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _description,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: 'Waktu Kegiatan',
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.event_outlined),
                          title: const Text('Tanggal'),
                          subtitle: Text(formatDate(_date)),
                          onTap: _pickDate,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: _TimeField(
                                label: 'Jam Mulai',
                                value: _startTime,
                                onTap: () => _pickTime(isStart: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TimeField(
                                label: 'Jam Selesai',
                                value: _endTime,
                                onTap: () => _pickTime(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        if (_timeError != null) ...<Widget>[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _timeError!,
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Section(
                    title: 'Titik Lokasi & Radius',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GeofenceMapPreview(
                          center: _point,
                          radiusMeters: _radius,
                          height: 200,
                          onTapPoint: _onMapTap,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.place_outlined,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _address ??
                                    '${_point.latitude.toStringAsFixed(5)}, '
                                        '${_point.longitude.toStringAsFixed(5)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            BlocBuilder<EventAddressBloc, EventAddressState>(
                              builder: (_, EventAddressState state) =>
                                  state.isLoading
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Radius Presensi: ${_radius.round()} Meter',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Slider(
                          value: _radius,
                          min: _minRadius,
                          max: _maxRadius,
                          divisions: 47,
                          label: '${_radius.round()} Meter',
                          onChanged: (double value) =>
                              setState(() => _radius = value),
                        ),
                        Text(
                          _radiusError ?? 'Minimal 30 meter untuk akurasi GPS dalam ruangan.',
                          style: TextStyle(
                            fontSize: 11,
                            color: _radiusError == null
                                ? AppColors.textSecondary
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 96),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.all(AppTheme.gap),
              child: SizedBox(
                height: AppTheme.minTouchTarget,
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Simpan & Jadwalkan Kegiatan'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onMapTap(GeoPoint point) {
    setState(() {
      _point = point;
      _address = null;
    });
    context.read<EventAddressBloc>().add(EventAddressLookupRequested(_point));
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  DateTime _combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  void _save() {
    final DateTime startAt = _combine(_date, _startTime);
    final DateTime endAt = _combine(_date, _endTime);

    final String? titleError = _title.text.trim().isEmpty
        ? 'Judul kegiatan wajib diisi'
        : null;
    final String? timeError = endAt.isAfter(startAt)
        ? null
        : 'Jam selesai harus setelah jam mulai';
    final String? radiusError = _radius < _minRadius
        ? 'Radius minimal 30 meter'
        : null;

    setState(() {
      _titleError = titleError;
      _timeError = timeError;
      _radiusError = radiusError;
    });

    if (titleError != null || timeError != null || radiusError != null) return;

    final Event result = Event(
      id: widget.event?.id ?? '',
      groupId: _groupId,
      title: _title.text.trim(),
      description: _description.text.trim(),
      location: EventLocation(
        point: _point,
        radiusMeters: _radius,
        address: _address,
      ),
      startAt: startAt,
      endAt: endAt,
      status: EventStatus.published,
      createdBy: widget.event?.createdBy,
      createdAt: widget.event?.createdAt,
    );

    Navigator.of(context).pop(result);
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.gap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _GroupDropdown extends StatelessWidget {
  const _GroupDropdown({
    required this.value,
    required this.groups,
    required this.onChanged,
  });

  final String value;
  final List<MapEntry<String, String>> groups;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        labelText: 'Kelompok',
        border: OutlineInputBorder(),
      ),
      items: groups
          .map(
            (MapEntry<String, String> group) => DropdownMenuItem<String>(
              value: group.key,
              child: Text(group.value),
            ),
          )
          .toList(),
      onChanged: (String? selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final TimeOfDay value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.controlRadius),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(formatTime(DateTime(2000, 1, 1, value.hour, value.minute))),
      ),
    );
  }
}
