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
      title: 'Course Explorer - Tahap 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      // Membungkus home langsung dengan ChangeNotifierProvider memastikan context selalu valid
      home: ChangeNotifierProvider(
        create: (_) => CourseProvider(),
        child: const ProviderSetupPage(),
      ),
    );
  }
}

class ProviderSetupPage extends StatelessWidget {
  const ProviderSetupPage({super.key});

  final List<Map<String, String>> _courses = const [
    {'code': 'TI2101', 'title': 'State Management & Architecture'},
    {'code': 'TI2102', 'title': 'Pemrograman Mobile Lanjut'},
    {'code': 'TI2103', 'title': 'Git & Version Control'},
  ];

  @override
  Widget build(BuildContext context) {
    // Membaca state CourseProvider dari context turunan
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 6: Provider Setup'),
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

            // Indikator Status Provider
            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Provider Berhasil Terpasang!',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Total Favorit: ${courseProvider.favoriteCount} Kursus',
                            style: TextStyle(fontSize: 12, color: Colors.green.shade900),
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
              'Akses Provider dari Widget Bawah',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._courses.map((course) {
              final String code = course['code']!;
              final bool isFav = courseProvider.isFavorite(code);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.school, color: Colors.blue),
                  title: Text(course['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(code),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<CourseProvider>().toggleFavorite(code);
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