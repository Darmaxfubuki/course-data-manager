import 'package:flutter/material.dart';

// Identitas Mahasiswa (Wajib)
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
      title: 'Course Explorer - Tahap 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const ParentCoursePage(),
    );
  }
}

// =========================================================================
// ANCESTOR (PARENT): Single Source of Truth
// =========================================================================
class ParentCoursePage extends StatefulWidget {
  const ParentCoursePage({super.key});

  @override
  State<ParentCoursePage> createState() => _ParentCoursePageState();
}

class _ParentCoursePageState extends State<ParentCoursePage> {
  // Nilai inisialisasi default
  bool _isFeaturedFavorite = false;

  void _toggleFeaturedFavorite() {
    setState(() {
      _isFeaturedFavorite = !_isFeaturedFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Memastikan fallback aman jika terjadi anomali hot-reload
    final bool currentStatus = _isFeaturedFavorite;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 3: Lifting State Up'),
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

            // WIDGET ANAK 1
            CourseSummaryCard(isFavorite: currentStatus),

            const SizedBox(height: 16),

            // WIDGET ANAK 2
            CourseCard(
              title: 'State Management & Architecture',
              code: 'TI2101',
              credits: 3,
              isFavorite: currentStatus,
              onFavoriteChanged: _toggleFeaturedFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET ANAK 1: Menerima boolean aman
// =========================================================================
class CourseSummaryCard extends StatelessWidget {
  final bool? isFavorite;

  const CourseSummaryCard({super.key, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    final bool active = isFavorite ?? false;

    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Icon(
              active ? Icons.bookmark : Icons.bookmark_border,
              color: active ? Colors.red : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Widget Status Ringkasan (Child 1)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    active
                        ? 'Status Kursus Unggulan: Disimpan di Favorit'
                        : 'Status Kursus Unggulan: Belum Favorit',
                    style: TextStyle(
                      fontSize: 12,
                      color: active ? Colors.red.shade700 : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// WIDGET ANAK 2: Kartu Interaktif
// =========================================================================
class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final int credits;
  final bool? isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
    required this.credits,
    this.isFavorite = false,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = isFavorite ?? false;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(Icons.school, color: Color(0xFF1E88E5)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$code • $credits SKS',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Toggle Favorite',
              icon: Icon(
                active ? Icons.favorite : Icons.favorite_border,
                color: active ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteChanged,
            ),
          ],
        ),
      ),
    );
  }
}