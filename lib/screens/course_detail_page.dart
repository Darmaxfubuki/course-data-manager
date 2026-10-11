import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final bool isFav = context.watch<CourseProvider>().isFavorite(course.code);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(course.code),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFCFD8DC), width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24),
                  Text('Kode: ${course.code}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                  Text('SKS: ${course.credits} SKS', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 6),
                  Text('Status: ${course.status}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  Text(
                    'Deskripsi:\n${course.description ?? "Tidak ada deskripsi."}',
                    style: TextStyle(color: Colors.grey.shade800, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFav ? Colors.red.shade600 : const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      label: Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
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