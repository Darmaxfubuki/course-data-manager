import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart';
import '../firebase_options.dart';

/// Top-level background message handler (dieksekusi saat aplikasi Background / Terminated)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('=== [BACKGROUND/TERMINATED] Notification: ${message.notification?.title} - ${message.notification?.body} | Data: ${message.data} ===');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Web Push Certificate (VAPID Key) dari Firebase Console:
  /// Project Settings -> Cloud Messaging -> Web configuration -> Web Push certificates -> Generate key pair.
  static String? webVapidKey;

  String? _currentToken;
  String? get currentToken => _currentToken;

  String? _tokenError;
  String? get tokenError => _tokenError;

  String _permissionStatus = 'notDetermined';
  String get permissionStatus => _permissionStatus;

  bool _isListenersConfigured = false;

  /// Inisialisasi sesuai panduan Praktik 10 Worksheet 9
  Future<void> init() async {
    await initAndGetToken();
  }

  /// Mengambil FCM Token (Praktik 9)
  Future<String?> getToken() async {
    if (_currentToken != null) return _currentToken;
    return await initAndGetToken();
  }

  /// Meminta izin notifikasi dan mengembalikan status izin
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _permissionStatus = settings.authorizationStatus.name;
    debugPrint('=== NOTIFICATION STATUS: ${settings.authorizationStatus.name} ===');
    return settings.authorizationStatus;
  }

  /// Inisialisasi izin, mengambil FCM token perangkat, menyimpan ke Supabase,
  /// serta mendaftarkan listener untuk Foreground, Background, dan Terminated.
  Future<String?> initAndGetToken() async {
    try {
      // 1. Meminta izin notifikasi
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      _permissionStatus = settings.authorizationStatus.name;
      debugPrint('=== NOTIFICATION STATUS: ${settings.authorizationStatus.name} ===');

      // 2. Mengambil token perangkat
      String? token;
      _tokenError = null;
      try {
        if (kIsWeb) {
          if (webVapidKey != null && webVapidKey!.isNotEmpty) {
            token = await _messaging.getToken(vapidKey: webVapidKey);
          } else {
            debugPrint('[NotificationService] Peringatan: FCM di Web memerlukan VAPID key.');
            _tokenError = 'Web memerlukan VAPID Key dari Firebase Console (atau jalankan di Android).';
            token = await _messaging.getToken();
          }
        } else {
          token = await _messaging.getToken();
        }
      } catch (e) {
        debugPrint('[NotificationService] Gagal mengambil token (Web/Platform): $e');
        _tokenError ??= 'Gagal mengambil token: $e';
      }

      _currentToken = token;
      debugPrint('=== FCM TOKEN: $token ===');

      // 3. Simpan ke Supabase tabel public.user_tokens jika user login
      if (token != null && _supabase.auth.currentUser != null) {
        await saveTokenToSupabase(token);
      }

      // 4. Dengarkan token refresh
      _messaging.onTokenRefresh.listen((newToken) async {
        debugPrint('[NotificationService] FCM Token diperbarui: $newToken');
        _currentToken = newToken;
        if (_supabase.auth.currentUser != null) {
          await saveTokenToSupabase(newToken);
        }
      });

      // 5. Daftarkan message listener (Foreground & Interaction) jika belum
      if (!_isListenersConfigured) {
        _isListenersConfigured = true;
        await _setupMessageListeners();
      }

      return token;
    } catch (e) {
      debugPrint('[NotificationService] Error in initAndGetToken: $e');
      return null;
    }
  }

  Future<void> _setupMessageListeners() async {
    // Tampilkan notifikasi di sistem saat foreground (iOS / Web)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // KONDISI 1: FOREGROUND (Aplikasi sedang aktif terbuka)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('=== [FOREGROUND] Notification Received ===');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body : ${message.notification?.body}');
      debugPrint('Data : ${message.data}');

      final title = message.notification?.title ?? 'Notifikasi Baru';
      final body = message.notification?.body ?? '';

      // Tampilkan banner notifikasi di dalam aplikasi (SnackBar mengambang)
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1976D2),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    });

    // KONDISI 2: BACKGROUND INTERACTION (Notifikasi di-tap saat aplikasi di background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('=== [BACKGROUND TAP] Notifikasi di-tap: ${message.notification?.title} | Data: ${message.data} ===');
    });

    // KONDISI 3: TERMINATED INTERACTION (Aplikasi dibuka dari kondisi tertutup penuh)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('=== [TERMINATED OPEN] Aplikasi dibuka dari notifikasi: ${initialMessage.notification?.title} | Data: ${initialMessage.data} ===');
    }
  }

  /// Simpan atau upsert token ke tabel user_tokens di Supabase
  Future<void> saveTokenToSupabase(String token) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      final platform = kIsWeb ? 'web' : defaultTargetPlatform.name;
      await _supabase.from('user_tokens').upsert({
        'user_id': user.id,
        'token': token,
        'platform': platform,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
      debugPrint('[NotificationService] Token berhasil disimpan ke tabel user_tokens');
    } catch (e) {
      debugPrint('[NotificationService] Gagal menyimpan token ke Supabase: $e');
    }
  }

  /// Hapus token perangkat saat logout
  Future<void> removeCurrentToken() async {
    try {
      if (_currentToken != null) {
        await _supabase.from('user_tokens').delete().eq('token', _currentToken!);
        _currentToken = null;
        debugPrint('[NotificationService] Token berhasil dihapus dari user_tokens');
      }
    } catch (e) {
      debugPrint('[NotificationService] Gagal menghapus token: $e');
    }
  }
}
