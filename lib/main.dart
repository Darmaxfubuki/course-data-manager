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
      title: 'Course Explorer - Tahap 10',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CourseProvider(repository: courseRepository),
        child: const CourseRepositoryPage(),
      ),
    );
  }
}

class CourseRepositoryPage extends StatelessWidget {
  const CourseRepositoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 10: Repository Pattern'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Identitas Mahasiswa
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

            // Indikator Repository Pattern
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
                    Icon(Icons.layers_outlined, color: Color(0xFF1E88E5), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Alur Data: UI -> Provider -> Repository -> Service berhasil terhubung.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Daftar Kursus via Repository Abstraction',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Membaca Future langsung dari Provider yang memanggil Repository
            FutureBuilder<List<Course>>(
              future: context.read<CourseProvider>().fetchCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Terjadi kesalahan: ${snapshot.error}'),
                    ),
                  );
                }

                final courses = snapshot.data ?? [];

                if (courses.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Belum ada data kursus yang tersedia.'),
                    ),
                  );
                }

                return Column(
                  children: courses.map((course) {
                    final bool isDone = course.status == 'done';
                    final bool isActive = course.status == 'active';
                    final Color statusColor = isDone
                        ? Colors.green
                        : (isActive ? const Color(0xFF1E88E5) : Colors.orange);

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
                        trailing: Consumer<CourseProvider>(
                          builder: (context, provider, child) {
                            final bool isFav = provider.isFavorite(course.code);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                context.read<CourseProvider>().toggleFavorite(course.code);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}