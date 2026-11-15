import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  final CourseDataSource dataSource;

  CourseRepository(this.dataSource);

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) =>
      dataSource.createCourse(course);

  Future<bool> updateCourse(int id, Course course) =>
      dataSource.updateCourse(id, course);

  Future<bool> deleteCourse(int id) =>
      dataSource.deleteCourse(id);
}
