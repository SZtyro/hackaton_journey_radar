import 'dart:ui';

abstract class LanguageConstants {
  static const pl = 'pl';
  static const en = 'en';
  static const plUpperCase = 'PL';
  static const enUpperCase = 'EN';
}

abstract class StorageKeys {
  static const themeModeKey = 'theme_mode';
  static const useDynamicKey = 'theme_use_dynamic';
  static const seedKey = 'theme_seed';
  static const userName = 'user_name';
  static const userLanguage = 'user_language';
  static const hasAskedPush = 'has_asked_push';
  static const firstLaunchKey = 'first_launch';
}

abstract class AppConstants {
  static const Color defaultSeed = Color(0xFF6750A4);
  static const String baseUrl = 'https://api.example.com';
}

abstract class DioNetworkConstants {
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
