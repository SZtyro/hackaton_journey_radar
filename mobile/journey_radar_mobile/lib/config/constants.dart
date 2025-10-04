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
  static const firstLaunchKey = 'is_first_launch';
}

abstract class AppConstants {
  static const Color defaultSeed = Color(0xFF6750A4);
  static const baseUrl = 'https://api.journeyradar.com';
  static const androidPushNotificationsChannelId =
      'journey_radar_mobile_channel_id';
  static const androidPushNotificationsChannelName =
      'Journey Radar Mobile Channel';
  static const androidPushNotificationsChannelDescription =
      'Journey Radar Mobile Channel Description';
  static const nativeAndroidDefaultIconPath = '@mipmap/ic_launcher';
}


abstract class DioNetworkConstants {
  static const connectTimeout = Duration(seconds: 45);
  static const receiveTimeout = Duration(seconds: 300);
  static const sendTimeout = Duration(seconds: 45);
}
