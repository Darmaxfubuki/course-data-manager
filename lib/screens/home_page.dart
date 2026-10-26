import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

// 1. Konstanta endpoint API latihan (Tahap 2)
const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

class HomePage extends StatefulWidget {
  final String studentName;
  final String studentId;

  const HomePage({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 2. Fungsi asynchronous HTTP GET (Tahap 2)
  Future<List<dynamic>> fetchCourses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      debugPrint('Berhasil memuat data. Jumlah item: ${data.length}');
      return data;
    }

    throw Exception('HTTP ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isWide = MediaQuery.of(context).size.width >= 640;

    // Filter daftar lokal untuk tab Favorites
    final displayCourses = _selectedIndex == 2
        ? provider.courses.where((c) => provider.isFavorite(c.code)).toList()
        : provider.courses;

    Widget bodyContent = SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // Identitas Mahasiswa (Wajib terlihat di bukti praktikum)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${widget.studentId} • ${widget.studentName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF102A43),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Summary Card: Courses & Favorites
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBCCCDC), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Courses',
                        style: TextStyle(fontSize: 13, color: Color(0xFF486581), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.courses.length}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF102A43)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBCCCDC), width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Favorites',
                        style: TextStyle(fontSize: 13, color: Color(0xFF486581), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.favoriteCount}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF102A43)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Tampilan Hasil HTTP GET via FutureBuilder (Tahap 2)
          FutureBuilder<List<dynamic>>(
            future: fetchCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // Kondisi saat simulasi endpoint salah (404)
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Terjadi Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final items = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBCCCDC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status HTTP GET: Berhasil (200 OK)',
                      style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jumlah item diterima dari API: ${items.length} item',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Tampilan daftar item
          if (provider.isLoading) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ] else if (displayCourses.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  _selectedIndex == 2 ? 'Belum ada mata kuliah favorit.' : 'Data kosong.',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ] else ...[
            ...displayCourses.map((course) {
              return CourseCard(
                course: course,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailPage(course: course),
                    ),
                  );
                },
              );
            }),
          ],
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Course Data Manager'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(icon: Icon(Icons.menu_book), label: Text('Courses')),
                    NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: bodyContent),
              ],
            )
          : bodyContent,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.menu_book), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
              ],
            ),
    );
  }
}