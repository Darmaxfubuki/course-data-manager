// lib/main.dart
// Identitas: I Ketut Darmawan Wirakusuma - 2415051021

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_keys.dart';
import 'config/supabase_config.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/auth_service.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Mendengarkan perubahan session (AuthChangeEvent.signedOut)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    debugPrint('Auth event: ${data.event}');
    if (data.event == AuthChangeEvent.signedOut) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  });

  // Data source aktif: Supabase (cukup ganti baris ini jika ingin kembali ke REST)
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

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
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,
      home: AuthService.instance.isLoggedIn
          ? const HomePage()
          : const LoginPage(),
    );
  }
}