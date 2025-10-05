import 'dart:ui';
import 'package:flutter/material.dart';

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
  static const appName = 'Journey Radar';
}

abstract class DioNetworkConstants {
  static const connectTimeout = Duration(seconds: 45);
  static const receiveTimeout = Duration(seconds: 300);
  static const sendTimeout = Duration(seconds: 45);
}

abstract class MarkerConstants {
  // Default values for AppMarker
  static const double defaultElevation = 4.0;
  static const double defaultBorderWidth = 2.0;
  static const double defaultShadowBlur = 8.0;
  static const double defaultShadowSpread = 2.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 200);

  // Selected marker values
  static const double selectedElevation = 8.0;
  static const double selectedShadowBlur = 12.0;
  static const double selectedShadowSpread = 3.0;

  // User location marker values
  static const double userLocationElevation = 6.0;
  static const double userLocationShadowBlur = 12.0;
  static const double userLocationShadowSpread = 3.0;

  // Default colors
  static const Color defaultIconColor = Colors.white;
  static const Color defaultBorderColor = Colors.white;
  static const Color defaultUserLocationColor = Colors.blue;
  static const Color defaultMapPointColor = Colors.orange;
  static const Color defaultBusStopColor = Colors.green;
  static const Color defaultLandmarkColor = Colors.purple;

  // Shadow opacity
  static const double shadowOpacity = 0.3;
}
