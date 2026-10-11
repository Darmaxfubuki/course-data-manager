import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

// ==========================================
// MODEL COURSE (Tahap 8)
// ==========================================
class Course {
  final String code;
  final String title;
  final int credits;
  final String status;
  final String? description;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'planned',
      description: json['description'] as String?,
    );
  }
}

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 8',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CourseProvider(),
        child: const CourseModelPage(),
      ),
    );
  }
}

class CourseModelPage extends StatelessWidget {
  const CourseModelPage({super.key});

  static const List<Map<String, dynamic>> _rawJsonData = [
    {
      'code': 'TI2101',
      'title': 'State Management & Architecture',
      'credits': 3,
      'status': 'active',
      'description': 'Membahas arsitektur Flutter dari setState hingga Provider.'
    },
    {
      'code': 'TI2102',
      'title': 'Pemrograman Mobile Lanjut',
      'credits': 3,
      'status': 'planned',
      'description': 'Navigasi lanjutan, API REST, dan manajemen basis data.'
    },
    {
      'code': 'TI2103',
      'title': 'Git & Version Control',
      'credits': 2,
      'status': 'done',
      'description': 'Manajemen branch, pull request, dan workflow kolaborasi.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Parsing JSON menjadi list object Course
    final List<Course> courseList = _rawJsonData
        .map((json) => Course.fromJson(json))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 8: Model Course'),
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

            // Indikator Model Sukses
            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.green.shade300),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data berhasil diparsing menjadi Object Model Course via Course.fromJson().',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Daftar Kursus (Strongly Typed Model)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ...courseList.map((course) {
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
            }),
          ],
        ),
      ),
    );
  }
}