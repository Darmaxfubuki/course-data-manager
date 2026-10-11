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
    } catch (e) {
      return [
        Course(
          code: 'TI2101',
          title: 'State Management & Architecture',
          credits: 3,
          status: 'active',
          description: 'Mempelajari Provider, Model, Service, dan Repository.',
        ),
        Course(
          code: 'TI2102',
          title: 'Pemrograman Mobile Lanjut',
          credits: 3,
          status: 'planned',
          description: 'Navigasi lanjutan, API REST, dan manajemen basis data.',
        ),
        Course(
          code: 'TI2103',
          title: 'Git & Version Control',
          credits: 2,
          status: 'done',
          description: 'Manajemen branch, pull request, dan workflow kolaborasi.',
        ),
      ];
    }
  }
}