import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/home_page.dart';
import 'services/course_api_service.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';  
const String studentId = '2415051021';  
const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

void main() {
  // Inisialisasi Service Layer dengan Base URL API latihan
  final courseApiService = CourseApiService(apiBaseUrl);
  // Inisialisasi Repository Layer
  final courseRepository = CourseRepository(courseApiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(courseRepository)..loadCourses(),
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Data Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      home: const HomePage(
        studentName: studentName,
        studentId: studentId,
      ),
    );
  }
}