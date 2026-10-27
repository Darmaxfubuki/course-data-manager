// lib/services/course_supabase_service.dart
// Identitas: I Ketut Darmawan Wirakusuma - 2415051021

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final payload = {
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
      'description': course.description,
    };

    final row = await supabase
        .from('courses')
        .insert(payload)
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final payload = {
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
      'description': course.description,
    };

    await supabase
        .from('courses')
        .update(payload)
        .eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    // Menghapus baris data di Supabase berdasarkan primary key 'id'
    await supabase
        .from('courses')
        .delete()
        .eq('id', id);
  }
}