import 'package:flutter/material.dart';
import 'course_state.dart';

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
      title: 'Course Explorer - Tahap 5',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const ChangeNotifierDemoPage(),
    );
  }
}

class ChangeNotifierDemoPage extends StatefulWidget {
  const ChangeNotifierDemoPage({super.key});

  @override
  State<ChangeNotifierDemoPage> createState() => _ChangeNotifierDemoPageState();
}

class _ChangeNotifierDemoPageState extends State<ChangeNotifierDemoPage> {
  // 1. Inisialisasi object ChangeNotifier
  final CourseState _courseState = CourseState();

  final List<Map<String, String>> _courses = const [
    {'code': 'TI2101', 'title': 'State Management & Architecture'},
    {'code': 'TI2102', 'title': 'Pemrograman Mobile Lanjut'},
    {'code': 'TI2103', 'title': 'Git & Version Control'},
  ];

  @override
  void initState() {
    super.initState();
    // Mendengarkan notifikasi perubahan dari notifyListeners()
    _courseState.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    // Rebuild saat ChangeNotifier memanggil notifyListeners()
    setState(() {});
  }

  @override
  void dispose() {
    // Hapus listener dan buang objek saat tidak digunakan
    _courseState.removeListener(_onStateChanged);
    _courseState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 5: ChangeNotifier Lab'),
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

            // Ringkasan Total Favorit dari ChangeNotifier
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.red, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Total Favorit (ChangeNotifier): ${_courseState.favoriteCount} Kursus',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // List Kursus yang memanggil toggleFavorite()
            const Text(
              'Daftar Topik Kursus',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._courses.map((course) {
              final String code = course['code']!;
              final bool isFav = _courseState.isFavorite(code);

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.blue),
                  title: Text(course['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(code),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Memanggil method perubahan state pada ChangeNotifier
                      _courseState.toggleFavorite(code);
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