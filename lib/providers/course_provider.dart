import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // Set menyimpan kode mata kuliah favorit
  final Set<String> _favorites = <String>{};
  Set<String> get favorites => Set.unmodifiable(_favorites);
  int get favoriteCount => _favorites.length;
  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan data baru dan refresh list (Tahap 6)
  Future<void> createCourse(Course course) async {
    await repository.createCourse(course);
    await loadCourses();
  }

  // Memperbarui data dan refresh list (Tahap 7)
  Future<void> updateCourse(int id, Course course) async {
    await repository.updateCourse(id, course);
    await loadCourses();
  }

  // Menghapus data, membersihkan dari favorit, dan refresh list (Tahap 8)
  Future<void> deleteCourse(Course course) async {
    if (course.id != null) {
      await repository.deleteCourse(course.id!);
      
      // Hapus dari favorites jika ada agar tidak meninggalkan data yatim
      if (_favorites.contains(course.code)) {
        _favorites.remove(course.code);
      }
      
      await loadCourses();
    }
  }
}