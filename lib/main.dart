// lib/main.dart
// Identitas: I Ketut Darmawan Wirakusuma - 2415051021

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/home_page.dart';
import 'services/course_api_service.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';
const String apiBaseUrl = 'https://course-api-pearl.vercel.app';

Future<void> main() async {
  // 1. Wajib dipanggil sebelum inisialisasi async pada Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Supabase Client menggunakan Publishable / Anon Key
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // 3. Perakitan service -> repository -> provider (Tahap 9 & 10)
  final apiService = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(apiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
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