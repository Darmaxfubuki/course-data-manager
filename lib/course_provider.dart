import 'package:flutter/foundation.dart';
import 'model/course.dart';
import 'repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository? repository;

  CourseProvider({this.repository});

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

  // 4. Provider mengambil data melalui repository
  Future<List<Course>> fetchCourses() async {
    if (repository != null) {
      return await repository!.getCourses();
    }
    return [];
  }
}