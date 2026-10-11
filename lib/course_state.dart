import 'package:flutter/foundation.dart';

/// Class pengelola state mata kuliah yang mengekstensi ChangeNotifier
class CourseState extends ChangeNotifier {
  // 2. Collection favorites untuk menyimpan kode mata kuliah favorit
  final Set<String> _favorites = <String>{};

  // Getter publik agar data favorites dapat dibaca (unmodifiable view)
  Set<String> get favorites => Set.unmodifiable(_favorites);

  // Getter total favorit
  int get favoriteCount => _favorites.length;

  // Memeriksa apakah suatu mata kuliah adalah favorit
  bool isFavorite(String code) => _favorites.contains(code);

  // 3 & 4. Method toggleFavorite() yang memanggil notifyListeners()
  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    // Wajib: beri tahu listener bahwa data berubah
    notifyListeners();
  }
}