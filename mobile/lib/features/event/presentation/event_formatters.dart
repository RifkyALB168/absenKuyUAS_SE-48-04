const List<String> _monthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Tanggal singkat, mis. `24 Okt 2026`.
String formatDate(DateTime value) =>
    '${value.day} ${_monthNames[value.month - 1]} ${value.year}';

/// Jam dengan zona WIB, mis. `15:00 WIB`.
String formatTime(DateTime value) =>
    '${_twoDigits(value.hour)}:${_twoDigits(value.minute)} WIB';

/// Jadwal lengkap kegiatan, mis. `24 Okt 2026 • 15:00 - 17:00 WIB`.
String formatSchedule(DateTime start, DateTime end) =>
    '${formatDate(start)} • ${formatTime(start)} - ${formatTime(end)}';

/// Jarak atau radius dalam meter, mis. `50m`.
String formatMeters(double meters) => '${meters.round()}m';
