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

  // Menambahkan course baru dan me-refresh daftar data (Tahap 6)
  Future<void> createCourse(Course course) async {
    await repository.createCourse(course);
    await loadCourses();
  }

  // Memperbarui course dan me-refresh daftar data secara penuh (Tahap 7)
  Future<void> updateCourse(int id, Course course) async {
    await repository.updateCourse(id, course);
    await loadCourses();
  }
}