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
# Course Data Manager (Flutter & Supabase)

Aplikasi mobile manajemen data mata kuliah (*Course Explorer v2*) berbasis Flutter yang menerapkan *Decoupled Architecture* (Model, DataSource, Repository, Provider, UI) dengan Supabase PostgreSQL sebagai backend cloud.

## Identitas Mahasiswa
- **Nama**: I Ketut Darmawan Wirakusuma
- **NIM**: 2415051021
- **Program Studi**: S1 Pendidikan Teknik Informatika
- **Jurusan**: Teknik Informatika
- **Fakultas**: Fakultas Teknik dan Kejuruan
- **Institusi**: Universitas Pendidikan Ganesha

---

## Deskripsi Aplikasi & Fitur
Course Data Manager dirancang untuk mengelola entitas mata kuliah secara terstruktur dan reaktif:
1. **Full CRUD Operations**:
   - **Create**: Penambahan mata kuliah melalui formulir tervalidasi.
   - **Read**: Menampilkan daftar course dari tabel Supabase secara terurut.
   - **Update**: Pembaruan judul, beban SKS, status, dan deskripsi course.
   - **Delete**: Penghapusan data berbasis `id` yang diproteksi dialog konfirmasi.
2. **State & UX Handling**:
   - Indikator pemuatan (*Loading state*) saat komunikasi asinkron berlangsung.
   - Tampilan data kosong (*Empty state*) jika tabel belum memiliki baris data.
   - Penanganan galat (*Error state*) dengan tombol *Retry* interaktif.
   - Umpan balik visual *SnackBar* pada setiap aksi berhasil maupun gagal.
3. **Responsive Navigation & Favorites**:
   - Navigasi responsif adaptif (`NavigationBar`).
   - Sistem penandaan course favorit berbasis `code` yang konsisten di lintas layar.

---

## Arsitektur Aplikasi
Aplikasi mengadopsi prinsip pemisahan tanggung jawab (*Separation of Concerns*):
- **Model (`lib/models/`)**: Representasi entitas `Course` beserta serialisasi dan deserialisasi JSON.
- **Service / DataSource (`lib/services/`)**: Kontrak antarmuka `CourseDataSource` dengan implementasi aktif `CourseSupabaseService` dan alternatif `CourseApiService` (REST).
- **Repository (`lib/repositories/`)**: `CourseRepository` mengisolasi sumber data dari logika bisnis aplikasi.
- **Provider (`lib/providers/`)**: `CourseProvider` mengelola *state* reaktif tanpa ketergantungan langsung pada paket HTTP atau Supabase.
- **Screens & Widgets (`lib/screens/`, `lib/widgets/`)**: Lapisan antarmuka pengguna responsif tanpa kueri database langsung.

---

## Backend & Keamanan
- **Backend**: Supabase (PostgreSQL Database, PostgREST API).
- **Row Level Security (RLS)**: Ditegakkan di tingkat tabel PostgreSQL sebagai lapisan otorisasi utama.
- **Data Integrity**: Memanfaatkan *CHECK constraint* pada kolom `status` (`'planned'`, `'active'`, `'done'`) serta integritas kunci primer.
- **Audit Keamanan**:
  - Hanya menggunakan `anonKey` (kunci publik) pada klien aplikasi.
  - Bebas dari kebocoran `service_role` key, token privat, maupun file `.env`.
  - Folder kompilasi `build/` diabaikan melalui konfigurasi `.gitignore`.

---

## Cara Menjalankan Proyek
1. Pastikan Flutter SDK dan Dart telah terkonfigurasi pada sistem.
2. Unduh pustaka dependensi:
   ```bash
   flutter pub get