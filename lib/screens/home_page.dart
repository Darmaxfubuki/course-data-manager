import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  final String studentName;
  final String studentId;

  const HomePage({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Course Explorer v2'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // 3. Tombol navigasi ke FavoritesPage dengan Badge jumlah
          Badge(
            label: Text('${provider.favoriteCount}'),
            isLabelVisible: provider.favoriteCount > 0,
            alignment: Alignment.topRight,
            child: IconButton(
              tooltip: 'Buka Kursus Favorit',
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Identitas Mahasiswa
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIM: $studentId',
                      style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Indikator Favorit
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.red, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Total Kursus Favorit: ${provider.favoriteCount} Kursus',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Lihat'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FavoritesPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Daftar Kursus (Klik untuk Detail / Toggle)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (provider.isLoading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ] else if (provider.error != null) ...[
              Center(
                child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)),
              ),
            ] else ...[
              ...provider.courses.map((course) {
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
      ),
    );
  }
}