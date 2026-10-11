import '../model/course.dart';
import '../services/course_service.dart';

/// Repository sebagai lapisan abstraksi antara data source (Service) dan Provider
class CourseRepository {
  final CourseService service;

  // 2. Menerima CourseService melalui constructor (Dependency Injection sederhana)
  CourseRepository(this.service);

  // 3. Method getCourses() untuk menyediakan data bagi Provider
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}