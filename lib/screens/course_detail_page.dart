import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // 2. Tampilkan status favorite secara reaktif di DetailPage
    final bool isFav = context.watch<CourseProvider>().isFavorite(course.code);

    final bool isDone = course.status == 'done';
    final bool isActive = course.status == 'active';
    final Color statusColor = isDone
        ? Colors.green
        : (isActive ? const Color(0xFF1E88E5) : Colors.orange);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(course.code),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: isFav ? 'Hapus Favorit' : 'Tambah Favorit',
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.redAccent : Colors.white,
            ),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(course.code);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: statusColor.withOpacity(0.15),
                        child: Icon(
                          isDone ? Icons.check_circle : Icons.school,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Text('Kode Mata Kuliah: ${course.code}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Beban SKS: ${course.credits} SKS', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Status Pelaksanaan: ${course.status}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(
                    'Status Favorit: ${isFav ? "Tersimpan di Favorit" : "Bukan Favorit"}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFav ? Colors.red : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Deskripsi:\n${course.description ?? "Belum ada deskripsi yang ditambahkan untuk mata kuliah ini."}',
                    style: TextStyle(color: Colors.grey.shade800, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFav ? Colors.red.shade600 : const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFav ? 'Hapus dari Favorit' : 'Tambahkan ke Favorit'),
                      onPressed: () {
                        context.read<CourseProvider>().toggleFavorite(course.code);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}