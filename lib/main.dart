import 'package:flutter/material.dart';

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
      title: 'Course Explorer - Tahap 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const ParentCoursePage(),
    );
  }
}

// =======================================================================
// 1. PARENT OWNS STATE: Menyimpan state tunggal favorites & mendistribusikannya
// =======================================================================
class ParentCoursePage extends StatefulWidget {
  const ParentCoursePage({super.key});

  @override
  State<ParentCoursePage> createState() => _ParentCoursePageState();
}

class _ParentCoursePageState extends State<ParentCoursePage> {
  // Satu nilai favorites pada parent
  final Set<String> _favoriteCourses = <String>{};

  // Data statis sederhana tanpa async/json agar ringan dan anti-error
  final List<Map<String, String>> _courses = [
    {'code': 'TI2101', 'title': 'State Management & Architecture', 'status': 'active'},
    {'code': 'TI2102', 'title': 'Pemrograman Mobile Lanjut', 'status': 'planned'},
    {'code': 'TI2103', 'title': 'Git & Version Control', 'status': 'done'},
  ];

  // Callback aksi untuk mengubah state di parent
  void _handleToggleFavorite(String code) {
    setState(() {
      if (_favoriteCourses.contains(code)) {
        _favoriteCourses.remove(code);
      } else {
        _favoriteCourses.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 2: Prop Drilling Lab'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Card Identitas Mahasiswa
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16),
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

            // CHILD 1: Menerima nilai favorite count dari parent via constructor
            FavoriteSummaryWidget(favoriteCount: _favoriteCourses.length),

            const SizedBox(height: 16),

            // CHILD 2: Menerima list data, set favorites, dan callback (Prop Drilling)
            CourseListContainer(
              courses: _courses,
              favoriteCourses: _favoriteCourses,
              onToggle: _handleToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================================
// 2. CHILD 1: Widget Ringkasan yang menerima nilai dari parent
// =======================================================================
class FavoriteSummaryWidget extends StatelessWidget {
  final int favoriteCount;

  const FavoriteSummaryWidget({super.key, required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Total Favorit Dipilih: $favoriteCount Kursus',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================================
// 3. CHILD 2: Container List (Pipa perantara prop drilling ke kartu item)
// =======================================================================
class CourseListContainer extends StatelessWidget {
  final List<Map<String, String>> courses;
  final Set<String> favoriteCourses;
  final ValueChanged<String> onToggle;

  const CourseListContainer({
    super.key,
    required this.courses,
    required this.favoriteCourses,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Topik Kursus',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...courses.map((course) {
          final String code = course['code']!;
          final bool isFav = favoriteCourses.contains(code);

          // Teruskan prop & callback ke child terdalam
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(course['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text('$code • Status: ${course['status']}'),
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
                onPressed: () => onToggle(code), // Panggil callback naik ke parent
              ),
            ),
          );
        }),
      ],
    );
  }
}