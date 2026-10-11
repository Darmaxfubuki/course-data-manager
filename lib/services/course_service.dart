import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/student_data.json',
      );
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final list = (data['courses'] as List<dynamic>?) ?? [];
      return list
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Fallback data simulasi 5 kursus (sesuai indikator Courses: 5 di mockup)
      return [
        Course(
          code: 'TI2101',
          title: 'Git & GitHub',
          credits: 2,
          status: 'done',
          description: 'Version control workflow, branch management, dan pull request review.',
        ),
        Course(
          code: 'TI2102',
          title: 'Dart Fundamentals',
          credits: 3,
          status: 'done',
          description: 'Dasar sintaksis Dart, OOP, Null Safety, dan Collections.',
        ),
        Course(
          code: 'TI2103',
          title: 'State Management',
          credits: 3,
          status: 'active',
          description: 'Penerapan setState, ValueNotifier, ChangeNotifier, dan Provider.',
        ),
        Course(
          code: 'TI2104',
          title: 'Mobile Architecture',
          credits: 3,
          status: 'planned',
          description: 'Separation of concerns, Repository pattern, dan Service layer.',
        ),
        Course(
          code: 'TI2105',
          title: 'UI & Responsive Layout',
          credits: 3,
          status: 'planned',
          description: 'Membangun antarmuka adaptif menggunakan NavigationBar dan NavigationRail.',
        ),
      ];
    }
  }
}