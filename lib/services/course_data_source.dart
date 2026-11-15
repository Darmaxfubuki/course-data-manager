import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<bool> updateCourse(int id, Course course);
  Future<bool> deleteCourse(int id);
}
