import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 7',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CourseProvider(),
        child: const WatchReadConsumerDemoPage(),
      ),
    );
  }
}

class WatchReadConsumerDemoPage extends StatelessWidget {
  const WatchReadConsumerDemoPage({super.key});

  final List<Map<String, String>> _courses = const [
    {'code': 'TI2101', 'title': 'State Management & Architecture'},
    {'code': 'TI2102', 'title': 'Pemrograman Mobile Lanjut'},
    {'code': 'TI2103', 'title': 'Git & Version Control'},
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Menggunakan context.watch() untuk mendengarkan perubahan state jumlah favorit
    final int totalFavorites = context.watch<CourseProvider>().favoriteCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 7: watch, read & Consumer'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
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

            // Demo 1: Menampilkan jumlah favorit menggunakan context.watch()
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    const Icon(Icons.remove_red_eye, color: Color(0xFF1E88E5), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dibaca via context.watch()',
                            style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total Favorit: $totalFavorites Kursus',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Daftar Topik Kursus (read & Consumer)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ..._courses.map((course) {
              final String code = course['code']!;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.school, color: Colors.blue),
                  title: Text(course['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(code),
                  // 3. Menggunakan Consumer untuk membatasi rebuild hanya pada tombol ikon favorit
                  trailing: Consumer<CourseProvider>(
                    builder: (context, provider, child) {
                      final bool isFav = provider.isFavorite(code);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        // 2. Menggunakan context.read() pada callback onPressed
                        onPressed: () {
                          context.read<CourseProvider>().toggleFavorite(code);
                        },
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}