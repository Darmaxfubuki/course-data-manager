# flutter_ui_fundamentals

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Course Explorer v2 - State Management & Architecture

Proyek ini dibangun sebagai implementasi praktikum State Management dan Arsitektur Aplikasi Flutter menggunakan Provider Pattern, Repository Pattern, dan Service Layer.

- **Nama Mahasiswa:** I Ketut Darmawan Wirakusuma
- **NIM:** 2415051021

---

## 🏛️ Tanggung Jawab Struktur Folder (Architecture Audit)

Arah dependensi yang diterapkan adalah satu arah:
`Screens / Widgets` ➔ `Providers` ➔ `Repositories` ➔ `Services` ➔ `Models`

1. **`lib/models/`**
   - Bertanggung jawab mendefinisikan entitas data bertipe pasti (*strongly typed*), skema atribut model (`Course`), serta logika serialisasi dan deserialisasi data (`fromJson` / `toJson`).
   - Tidak memiliki dependensi ke layer lain maupun Flutter UI.

2. **`lib/services/`**
   - Bertanggung jawab terhadap detail teknis pengambilan data mentah (*data source*), seperti membaca berkas aset JSON (`rootBundle`), decoding JSON, atau pemanggilan REST API eksternal.
   - Tidak boleh memuat komponen UI/Widget.

3. **`lib/repositories/`**
   - Bertindak sebagai lapisan abstraksi antara data source dan state management.
   - Mengisolasi perubahan sumber data (misal migrasi dari JSON lokal ke REST API) agar layer Provider dan UI tidak terdampak.

4. **`lib/providers/`**
   - Berfungsi sebagai pengelola status aplikasi (*state holder*) menggunakan `ChangeNotifier`.
   - Mengatur siklus hidup *async state* (`isLoading`, `error`, `courses`) serta *application state* (`favorites`) sebagai *Single Source of Truth*.
   - Tidak menyimpan referensi `BuildContext` sebagai state.

5. **`lib/screens/`**
   - Merepresentasikan antarmuka halaman penuh (`HomePage`, `CourseDetailPage`, `DebuggingLabPage`).
   - Bertanggung jawab atas navigasi dan tata letak responsif (`NavigationBar` / `NavigationRail`).

6. **`lib/widgets/`**
   - Komponen UI modular yang dapat digunakan kembali (*reusable widgets*), seperti `CourseCard`.
   - Menampilkan data dari model dan memicu aksi provider via `context.read()`.

## Dokumentasi REST API Latihan (Tahap 1)
- **Base URL:** `https://course-api-pearl.vercel.app`
- **Endpoint:** `/courses`
- **HTTP Method:** `GET`
- **Status Code:** `200 OK`
- **Resource:** `courses`
- **Contoh Response JSON:**
  ```json
  [
    {
      "id": 1,
      "code": "MOB01",
      "title": "Git & GitHub",
      "credits": 2,
      "status": "active"
    }
  ]

## Tahap 11 - Database Supabase
- Pembuatan tabel `courses` dengan kolom `id`, `code`, `title`, `credits`, `status`, `description`, dan `created_at`.
- Penerapan CHECK constraint pada status (`planned`, `active`, `done`).
- Konfigurasi Row Level Security (RLS) dan penambahan data awal.

## Verifikasi Pengujian & Debugging (Tahap 17)

Aplikasi telah melalui pengujian ketahanan sistem dan penanganan eksepsi:
- **Kasus A (Endpoint Invalid / 404)**: Menguji kueri ke tabel yang tidak terdaftar; aplikasi menangkap galat `PGRST205` dan menampilkan *error view* dengan tombol pemulihan.
- **Kasus B (Network Failure)**: Menguji aplikasi saat koneksi internet terputus; *state loading* berhenti normal dan pesan kegagalan soket ditampilkan tanpa *force close*.
- **Kasus C (JSON Mapping Error)**: Menguji ketidakcocokan *key* deserialisasi; sistem menangkap *type cast exception* secara aman.
- **Kasus D (Supabase RLS & Permissions)**: Menguji proteksi hak akses otentikasi dan kebijakan Row Level Security pada tabel PostgreSQL.
- **Kasus E (Data Constraints)**: Memverifikasi penegakan *CHECK constraint* (kolom status) dan keunikan data di tingkat backend database saat menerima *payload* tidak valid.

---