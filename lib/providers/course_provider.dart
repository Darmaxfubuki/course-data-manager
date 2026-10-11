import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // Debugging flag Kasus A: Kontrol apakah notifyListeners() dipanggil
  bool enableNotifyListeners = true;

  // Debugging flag Kasus C: Kontrol simulasi error
  bool simulateServiceError = false;

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

    // Kasus A: Jika enableNotifyListeners false, data berubah tapi UI TIDAK rebuild
    if (enableNotifyListeners) {
      notifyListeners();
    }
  }

  void setNotifyListenersStatus(bool value) {
    enableNotifyListeners = value;
    notifyListeners();
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Kasus C: Simulasi kegagalan pada service layer
      if (simulateServiceError) {
        await Future.delayed(const Duration(milliseconds: 600));
        throw Exception('Simulasi: Gagal menghubungkan ke data source (Error 500)');
      }

      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void triggerSimulatedError() {
    simulateServiceError = true;
    loadCourses();
  }

  void resetErrorAndReload() {
    simulateServiceError = false;
    loadCourses();
  }
}