import 'package:flutter/material.dart';

const String studentName = 'I Ketut Darmawan Wirakusuma';
const String studentId = '2415051021';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const ValueNotifierDemoPage(),
    );
  }
}

class ValueNotifierDemoPage extends StatefulWidget {
  const ValueNotifierDemoPage({super.key});

  @override
  State<ValueNotifierDemoPage> createState() => _ValueNotifierDemoPageState();
}

class _ValueNotifierDemoPageState extends State<ValueNotifierDemoPage> {
  // 1. Buat ValueNotifier<int> untuk nilai sederhana (misal counter favorit)
  final ValueNotifier<int> _favoriteCounter = ValueNotifier<int>(0);

  @override
  void dispose() {
    // Praktik terbaik: selalu dispose notifier saat widget dihancurkan
    _favoriteCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text('Tahap 4: ValueNotifier'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Card Identitas Mahasiswa
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NIM: $studentId',
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Tampilkan nilai menggunakan ValueListenableBuilder
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Favorite Counter',
                            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _favoriteCounter,
                            builder: (context, value, child) {
                              return Text(
                                '$value Kursus',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E88E5),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Tombol untuk memodifikasi nilai ValueNotifier
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kontrol Nilai (Aksi Listener)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E88E5),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah (+1)'),
                            onPressed: () {
                              _favoriteCounter.value++;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.remove),
                            label: const Text('Kurang (-1)'),
                            onPressed: () {
                              if (_favoriteCounter.value > 0) {
                                _favoriteCounter.value--;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          tooltip: 'Reset',
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            _favoriteCounter.value = 0;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}