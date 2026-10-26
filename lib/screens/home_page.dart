import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'add_course_page.dart';
import 'course_detail_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final isWide = MediaQuery.of(context).size.width >= 640;

    // Filter daftar course sesuai navigasi tab
    final displayCourses = _selectedIndex == 2
        ? provider.courses.where((c) => provider.isFavorite(c.code)).toList()
        : provider.courses;

    Widget bodyContent = SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // 1. Identitas Mahasiswa (Nama & NIM)
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

          // 2. Summary Card: Courses & Favorites
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
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF486581),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.courses.length}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF102A43),
                        ),
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
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF486581),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.favoriteCount}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF102A43),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Penanganan Empat State Asynchronous: Loading, Error, Empty, dan Success
          if (provider.isLoading) ...[
            // State: Loading
            const Center(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ] else if (provider.error != null) ...[
            // State: Error
            ErrorView(
              message: provider.error!,
              onRetry: () => context.read<CourseProvider>().loadCourses(),
            ),
          ] else if (displayCourses.isEmpty) ...[
            // State: Empty
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: Color(0xFF9FB3C8),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedIndex == 2
                          ? 'Belum ada mata kuliah favorit.'
                          : 'Data course belum tersedia.',
                      style: const TextStyle(
                        color: Color(0xFF627D98),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // State: Success
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
      // FloatingActionButton untuk membuka layar tambah data (Tahap 6)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCoursePage()),
          );
        },
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Course'),
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