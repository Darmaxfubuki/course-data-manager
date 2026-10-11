import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class DebuggingLabPage extends StatefulWidget {
  final String studentName;
  final String studentId;

  const DebuggingLabPage({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<DebuggingLabPage> createState() => _DebuggingLabPageState();
}

class _DebuggingLabPageState extends State<DebuggingLabPage> {
  // Variabel untuk Kasus D (Async State & mounted check)
  bool _isLocalAsyncLoading = false;
  String _asyncStatusMessage = 'Belum dijalankan';

  // Kasus D: Simulasi Async dengan pemeriksaan mounted yang aman
  Future<void> _runAsyncOperationWithMountedCheck() async {
    setState(() {
      _isLocalAsyncLoading = true;
      _asyncStatusMessage = 'Sedang memproses asinkron (2 detik)...';
    });

    // Menunggu proses asinkron
    await Future.delayed(const Duration(seconds: 2));

    // Wajib: Periksa apakah widget masih terpasang pada widget tree sebelum memanggil setState
    if (!mounted) return;

    setState(() {
      _isLocalAsyncLoading = false;
      _asyncStatusMessage = 'Operasi asinkron selesai dengan aman (mounted: true)!';
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Tahap 15: Debugging Lab'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Identitas Mahasiswa
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.studentId} •${widget.studentName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF102A43)),
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // KASUS A: Efek notifyListeners()
            // ==========================================
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFBCCCDC)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kasus A: Simulasi notifyListeners()',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ketika switch MATI, fungsi toggleFavorite tetap memodifikasi Set favorit, namun UI counter tidak menerima sinyal pembaruan.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const Divider(height: 18),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Panggil notifyListeners()', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        provider.enableNotifyListeners ? 'Aktif (UI akan ter-update)' : 'Nonaktif (UI TIDAK akan berubah)',
                        style: TextStyle(
                          fontSize: 11,
                          color: provider.enableNotifyListeners ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: provider.enableNotifyListeners,
                      onChanged: (val) {
                        context.read<CourseProvider>().setNotifyListenersStatus(val);
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          'Counter Favorit UI: ${provider.favoriteCount}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.favorite, size: 16),
                          label: const Text('Toggle TI2101'),
                          onPressed: () {
                            context.read<CourseProvider>().toggleFavorite('TI2101');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ==========================================
            // KASUS B: ProviderNotFoundException
            // ==========================================
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFBCCCDC)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kasus B: Context Scope & Ancestor Rule',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Provider hanya dapat ditemukan jika context merupakan anak (descendant) dari ChangeNotifierProvider. Membungkus MaterialApp di root menyelesaikan isu navigasi antar rute.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Status: Context valid, Provider terdaftar di root tree.',
                              style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ==========================================
            // KASUS C: Simulasi Error State pada Service
            // ==========================================
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFBCCCDC)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kasus C: Penanganan Error State Asinkron',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Menguji apakah UI secara reaktif merespons kegagalan data source dari CourseService dan memunculkan error state.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 10),
                    if (provider.isLoading) ...[
                      const Center(child: CircularProgressIndicator())
                    ] else if (provider.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Pesan Galat: ${provider.error}',
                              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Coba Lagi (Reset)'),
                              onPressed: () => context.read<CourseProvider>().resetErrorAndReload(),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          const Text('Status Data: Normal', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                          const Spacer(),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            icon: const Icon(Icons.warning_amber_rounded, size: 16),
                            label: const Text('Simulasi Error'),
                            onPressed: () => context.read<CourseProvider>().triggerSimulatedError(),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ==========================================
            // KASUS D: Async State & Pengecekan mounted
            // ==========================================
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFBCCCDC)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kasus D: Pengecekan mounted Pasca-Async',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Memanggil setState() setelah await tanpa `if (!mounted) return;` berpotensi memicu error memori jika pengguna menutup widget saat proses async masih berjalan.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Status: $_asyncStatusMessage',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _isLocalAsyncLoading ? Colors.orange.shade800 : const Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isLocalAsyncLoading
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.play_arrow, size: 18),
                        label: Text(_isLocalAsyncLoading ? 'Sedang Berjalan...' : 'Uji Operasi Async Aman'),
                        onPressed: _isLocalAsyncLoading ? null : _runAsyncOperationWithMountedCheck,
                      ),
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