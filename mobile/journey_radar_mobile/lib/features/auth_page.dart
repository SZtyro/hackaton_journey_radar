import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/config/firebase_push_notifications_service.dart';
import 'package:journey_radar_mobile/config/logger.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/config/language_provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final firebaseApi = getIt<FirebasePushNotificationService>();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      // Get the current language
      final languageProvider = getIt<LanguageProvider>();
      final currentLanguage = languageProvider.currentLocale.languageCode;

      // Initialize notifications
      await firebaseApi.initNotifications(
        context: context,
        languageCode: currentLanguage,
      );

      // Get and log the FCM token
      final fcmToken = await firebaseApi.getFCMToken();
      logD('FCM Token: $fcmToken');

      // Log that initialization is complete
      logD('Firebase push notifications initialized successfully');
    } catch (e) {
      logD('Error initializing notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Auth Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final fcmToken = await firebaseApi.getFCMToken();
                logD('FCM Token: $fcmToken');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('FCM Token: ${fcmToken ?? 'No token'}'),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
              child: const Text('Get FCM Token'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _initializeNotifications();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications re-initialized'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Re-initialize Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
