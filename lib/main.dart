import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';
import 'model/course.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final courseService = CourseService();
    final courseRepository = CourseRepository(courseService);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 11',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        // Inisialisasi Provider dan langsung panggil loadCourses()
        create: (_) => CourseProvider(courseRepository)..loadCourses(),
        child: const CourseAsyncPage(),
      ),
    );
  }
}

class CourseAsyncPage extends StatelessWidget {
  const CourseAsyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 11: Async State'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Tombol refresh untuk memicu reload state
          IconButton(
            tooltip: 'Reload Data',
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CourseProvider>().loadCourses(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Card Identitas Mahasiswa
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NIM: $studentId',
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Indikator Async State
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.shade300),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.sync, color: Color(0xFF1E88E5), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Async State dikelola mandiri oleh CourseProvider (Loading, Error, Success).',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Daftar Kursus (Async UI State)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ========================================================
            // PENANGANAN ASYNC STATE PADA UI (Poin 3, 4, dan 5)
            // ========================================================
            // 3. Tampilkan CircularProgressIndicator saat loading
            if (provider.isLoading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Memuat data kursus...'),
                    ],
                  ),
                ),
              ),
            ]
            // 4. Tampilkan pesan jika terjadi error
            else if (provider.error != null) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'Terjadi kesalahan: ${provider.error}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<CourseProvider>().loadCourses(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ]
            // 5. Tampilkan daftar kartu jika data berhasil dimuat (Success)
            else if (provider.courses.isEmpty) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Tidak ada data kursus yang tersedia.'),
                ),
              ),
            ] else ...[
              ...provider.courses.map((course) {
                final bool isDone = course.status == 'done';
                final bool isActive = course.status == 'active';
                final Color statusColor = isDone
                    ? Colors.green
                    : (isActive ? const Color(0xFF1E88E5) : Colors.orange);

                final bool isFav = provider.isFavorite(course.code);

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: statusColor.withOpacity(0.15),
                      child: Icon(
                        isDone ? Icons.check_circle : Icons.school,
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        context.read<CourseProvider>().toggleFavorite(course.code);
                      },
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}