import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/config/firebase_push_notifications_service.dart';
import 'package:journey_radar_mobile/config/language_provider.dart';
import 'package:journey_radar_mobile/config/logger.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/features/incident_reporting_page.dart';
import 'package:journey_radar_mobile/features/map/map.dart';
import 'package:journey_radar_mobile/features/schedule_page.dart';
import 'package:journey_radar_mobile/features/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final firebaseApi = getIt<FirebasePushNotificationService>();

  final List<Widget> _pages = [
    const MapPage(),
    const SchedulePage(),
    const IncidentReportingPage(),
    const SettingsPage(),
  ];

  final List<AppBottomNavigationItem> _navigationItems = [
    AppBottomNavigationItem(
      icon: const Icon(Icons.map_outlined),
      activeIcon: const Icon(Icons.map),
      label: 'Mapa',
      tooltip: 'Otwórz mapę Krakowa',
    ),
    AppBottomNavigationItem(
      icon: const Icon(Icons.schedule_outlined),
      activeIcon: const Icon(Icons.schedule),
      label: 'Rozkład',
      tooltip: 'Rozkład jazdy',
    ),
    AppBottomNavigationItem(
      icon: const Icon(Icons.report_problem_outlined),
      activeIcon: const Icon(Icons.report_problem),
      label: 'Zgłoś incydent',
      tooltip: 'Zgłoś incydent na trasie',
    ),
    AppBottomNavigationItem(
      icon: const Icon(Icons.settings_outlined),
      activeIcon: const Icon(Icons.settings),
      label: 'Ustawienia',
      tooltip: 'Ustawienia aplikacji',
    ),
  ];

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
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navigationItems,
        variant: AppBottomNavigationVariant.default_,
      ),
    );
  }
}
