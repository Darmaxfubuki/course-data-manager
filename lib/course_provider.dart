import 'package:flutter/foundation.dart';
import 'model/course.dart';
import 'repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  // 1. Jadikan repository sebagai dependency wajib
  final CourseRepository repository;

  CourseProvider(this.repository);

  // State async holder
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // Favorites state
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

  // 2. Implementasi method loadCourses() dengan siklus async state
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
}