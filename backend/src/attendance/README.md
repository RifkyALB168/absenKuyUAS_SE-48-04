# Integrasi API presensi

Daftarkan `registerAttendanceRoute(router, { authenticate, multer, pool, photoStore })` pada router API HTTPS. Modul memakai penamaan tabel PRD sebagai kontrak awal sampai migrasi utama tersedia.

- `authenticate` memverifikasi sesi dan mengisi `req.user.id`. Rute memeriksa ulang akun aktif dengan email terverifikasi, keanggotaan aktif, UKM aktif, dan kegiatan yang dipublikasikan.
- `pool` merupakan pool MySQL2 dengan API Promise. Gunakan InnoDB. Modul memakai kolom `events(id, group_id, lat, lng, radius_m, window_open, window_close, status)`, `user_groups(id, status)`, `memberships(user_id, group_id, status)`, dan `users(id, status, email_verified_at)`. Kegiatan yang bisa dipresensi berstatus `published`. Simpan `window_open` dan `window_close` dalam UTC.
- Tabel `attendances` perlu `id` auto-increment, `event_id`, `user_id`, `lat`, `lng`, `jarak_m`, `accuracy_m`, `photo_path`, `is_mocked`, `status`, `request_id` dan `created_at` UTC. Wajib ada unique key `(event_id, user_id)`. `request_id` menampung 32 karakter hex.
- `photoStore.put(buffer, mimeType)` memvalidasi dan menyimpan gambar ke penyimpanan privat, lalu mengembalikan ID file yang dibuat server. `photoStore.remove(key)` menghapus salinan yang batal dicatat. Saat hasil commit tidak pasti, pertahankan file dan rekonsiliasi dengan database sebelum membersihkannya.
- Middleware error umum perlu mengirim HTTP 5xx dengan JSON untuk kegagalan tak terduga. Gunakan pembatasan request dan monitoring di server, serta periksa authorization saat bukti diambil dari penyimpanan privat.

Klien mengirim `Authorization: Bearer <token>` dan `Idempotency-Key`, dengan field multipart `latitude`, `longitude`, `accuracy`, `is_mocked` dan file `photo` (JPEG/PNG/WebP sampai 2 MiB). ID kegiatan merupakan ID positif dalam format angka. Server memakai koordinat kegiatan dari database, menghitung ulang jarak, menggunakan waktu saat request diterima, dan menganggap jendela presensi terbuka pada waktu buka sampai sebelum waktu tutup.

Respons pertama `201 {"id": ..., "status": "hadir"}`. Pengulangan kunci yang sama mengembalikan `200` dengan catatan yang sama. Kunci lain untuk peserta dan kegiatan yang sudah tercatat menghasilkan `409 ALREADY_ATTENDED`. Keputusan ditolak menggunakan field `code`.

Flutter memakai `AttendanceApi` yang menerima base URL dan pembaca token sesi. Setelah M1 tersedia, berikan repository itu ke `MainPage` dan sediakan data kegiatan API ke `EventListPage`. Alur demo menguji GPS serta kamera lokal, sementara pengiriman tersedia bagi kegiatan server yang sah.
