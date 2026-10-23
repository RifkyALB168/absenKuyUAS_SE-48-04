# absenKuy

Presensi kegiatan UKM dan organisasi mahasiswa berbasis geofence dan bukti foto selfie.
Tugas besar Pemrograman Perangkat Bergerak, kelas SE-48-04.

| Anggota | NIM | PIC |
| --- | --- | --- |
| Rifky Albuchori | 103022400126 | Setup proyek & Clean Architecture, Splash, BottomNavigationBar, M4 Presensi, S2 Mock location |
| Affan Salim Yuan Utomo | 103022400058 | Infra backend, M1 Autentikasi, S4 Sesi SQLite |
| Ibnu Hafidz | 103022400064 | M3 Kegiatan, M5 Peta |
| Daniartha Wikus Nugroho | 103022400119 | Desain UI (tema & komponen bersama), M9 Error handling, M6 Riwayat, S3 Skor keaktifan |
| Khalifa Fattan Ahmad | 103022400086 | M2 Kelompok, M7 Rekap, M8 Notifikasi, S1 Izin |

Desain UI: [Figma absenKuy](https://www.figma.com/design/xPvBnz7jcfna56oO7WGZ52/absenKuy)

## Struktur repository

```
mobile/    Aplikasi Flutter (Android)
backend/   REST API Node.js + Express + MySQL
docs/      Dokumen dan wireframe (docs/design)
```

## Menjalankan aplikasi mobile

Butuh Flutter 3.x (stable) dan Android SDK.

```bash
cd mobile
flutter pub get
flutter run
```

Secara default aplikasi menghubungi backend di `http://10.0.2.2:3000` (localhost komputer jika dilihat dari emulator). Untuk HP fisik atau server yang sudah di-deploy:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000
```

HTTP tanpa enkripsi hanya diizinkan di build debug. Build release wajib memakai HTTPS.

## Arsitektur aplikasi (Clean Architecture)

```
mobile/lib/
  main.dart, app.dart
  core/
    constants/   konfigurasi (base URL API, dll.)
    error/       kelas exception dan failure bersama (M9)
    theme/       warna, tipografi, ThemeData (mengikuti desain Figma)
    usecase/     kontrak dasar UseCase
    utils/       helper (mis. Haversine)
    widgets/     komponen UI bersama (kartu, tombol, empty state, banner offline)
  features/
    auth/ group/ event/ attendance/ report/
      presentation/  pages, widgets, bloc
      domain/        entities, repositories (abstract), usecases
      data/          models, datasources (remote via http, local via sqflite), repositories (impl)
```

Aturan ketergantungan: `presentation` -> `domain` <- `data`. Layer `domain` tidak meng-import Flutter, `http`, atau `sqflite`. Repository di `domain` berupa abstract class, sehingga UI bisa dikembangkan dengan data dummy lalu diganti ke REST API tanpa mengubah `presentation`.

## Package utama

| Kebutuhan | Package |
| --- | --- |
| State management | `flutter_bloc`, `equatable` |
| REST API | `http` |
| Sesi lokal | `sqflite`, `path` |
| Kamera | `image_picker` |
| Lokasi GPS | `geolocator` |
| Peta | `google_maps_flutter` |
| Notifikasi | `flutter_local_notifications`, `timezone` |
| File | `path_provider` |
| Format tanggal | `intl` |
| Testing | `bloc_test`, `mocktail` |

## Aturan kerja Git

- Setiap fitur dikerjakan di branch sendiri, mis. `feature/m4-presensi`.
- Gabung ke `main` lewat pull request yang ditinjau minimal satu anggota lain.
- Commit rutin dengan pesan yang jelas.
