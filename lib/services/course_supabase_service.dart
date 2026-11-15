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
    final uid = supabase.auth.currentUser?.id;
    final payload = {
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
      'description': course.description,
      if (uid != null) 'owner_id': uid,
    };

    final row = await supabase
        .from('courses')
        .insert(payload)
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<bool> updateCourse(int id, Course course) async {
    final payload = {
      'code': course.code,
      'title': course.title,
      'credits': course.credits,
      'status': course.status,
      'description': course.description,
    };

    final rows = await supabase
        .from('courses')
        .update(payload)
        .eq('id', id)
        .select();

    return (rows as List).isNotEmpty;
  }

  @override
  Future<bool> deleteCourse(int id) async {
    final rows = await supabase
        .from('courses')
        .delete()
        .eq('id', id)
        .select();

    return (rows as List).isNotEmpty;
  }
}
