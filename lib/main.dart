import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

void main() {
  runApp(const CourseExplorerApp());
}

// Fungsi pembaca data JSON aset
Future<Map<String, dynamic>> loadStudentData() async {
  try {
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    return jsonDecode(jsonString) as Map<String, dynamic>;
  } catch (e) {
    // Fallback data jika file json belum ditemukan
    return {
      'courses': [
        {
          'code': 'TI2101',
          'title': 'State Management & Architecture',
          'credits': 3,
          'status': 'active',
          'grade': 'A',
          'description': 'Mempelajari arsitektur Flutter dari setState hingga Provider.'
        },
        {
          'code': 'TI2102',
          'title': 'Pemrograman Mobile Lanjut',
          'credits': 3,
          'status': 'planned',
          'grade': '-',
          'description': 'Mendalami widget tree, routing, dan integrasi backend API.'
        },
        {
          'code': 'TI2103',
          'title': 'Git & Version Control',
          'credits': 2,
          'status': 'done',
          'grade': 'A',
          'description': 'Workflow Git, branch management, dan continuous integration.'
        },
      ]
    };
  }
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(),
    );
  }
}

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Terjadi kesalahan: ${snapshot.error}')),
          );
        }

        final data = snapshot.data ?? {};
        final courses = (data['courses'] as List<dynamic>?) ?? [];

        final List<Widget> pages = [
          HomePage(courses: courses),
          CoursesPage(courses: courses),
          const ProfilePage(),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FB),
          appBar: AppBar(
            title: const Text(
              'Course Explorer v2',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SafeArea(child: pages[_selectedIndex]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= WIDGET: HEADER IDENTITAS =================
class StudentHeaderCard extends StatelessWidget {
  final String subtitle;

  const StudentHeaderCard({
    super.key,
    this.subtitle = 'Pendidikan Teknik Informatika • Semester 5',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: const AssetImage('assets/images/profile.jpeg'),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIM: $studentId',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade800,
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

// ================= WIDGET: ITEM CARD DENGAN LOCAL STATE (setState) =================
class LocalStateCourseCard extends StatefulWidget {
  final Map<String, dynamic> course;

  const LocalStateCourseCard({super.key, required this.course});

  @override
  State<LocalStateCourseCard> createState() => _LocalStateCourseCardState();
}

class _LocalStateCourseCardState extends State<LocalStateCourseCard> {
  // IMPLEMENTASI TAHAP 1: LOCAL STATE DENGAN setState()
  bool _isFavoriteLocal = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final String status = course['status'] as String? ?? 'planned';
    final bool isDone = status == 'done';
    final bool isActive = status == 'active';

    final Color statusColor =
        isDone ? Colors.green : (isActive ? Colors.blue : Colors.orange);
    final String statusLabel =
        isDone ? 'Selesai' : (isActive ? 'Berjalan' : 'Rencana');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.15),
                  child: Icon(
                    isDone ? Icons.check_circle : Icons.book,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${course['code']} • ${course['credits']} SKS • $statusLabel',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
                // Local State Action: Toggle Favorite Lokal
                IconButton(
                  tooltip: 'Favorit Lokal (setState)',
                  icon: Icon(
                    _isFavoriteLocal ? Icons.favorite : Icons.favorite_border,
                    color: _isFavoriteLocal ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavoriteLocal = !_isFavoriteLocal;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Local State Action: Expand/Collapse
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(
                _isExpanded ? 'Sembunyikan Deskripsi' : 'Tampilkan Deskripsi',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course['description'] ?? 'Tidak ada deskripsi rinci materi.',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ================= TAB 1: HOME PAGE =================
class HomePage extends StatelessWidget {
  final List<dynamic> courses;

  const HomePage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final int totalCredits = courses.fold<int>(
      0,
      (sum, item) => sum + (item['credits'] as int? ?? 0),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StudentHeaderCard(subtitle: 'Dashboard Portal Pembelajaran'),
          const SizedBox(height: 16),
          const Text(
            'Statistik Kursus',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Topik', '${courses.length}', Icons.menu_book, Colors.blue),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard('Total SKS', '$totalCredits', Icons.credit_card, Colors.purple),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard('Favorit', 'Local', Icons.favorite, Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tahap 1: Eksperimen State',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Divider(height: 16),
                  const Text(
                    'Perhatikan bahwa pada tab "Courses", setiap kartu mengelola state favoritnya sendiri menggunakan setState(). State tersebut tidak saling berbagi (belum berupa shared state).',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ================= TAB 2: COURSES PAGE =================
class CoursesPage extends StatelessWidget {
  final List<dynamic> courses;

  const CoursesPage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index] as Map<String, dynamic>;
        return LocalStateCourseCard(course: course);
      },
    );
  }
}

// ================= TAB 3: PROFILE PAGE =================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const StudentHeaderCard(),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Pengembang',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Nama: $studentName'),
                  const SizedBox(height: 4),
                  Text('NIM: $studentId'),
                  const SizedBox(height: 4),
                  const Text('Fokus: Pertemuan 6 - State Management & Architecture'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}