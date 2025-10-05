import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

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

abstract class MapConstants {
  // Map center coordinates
  static const LatLng krakowCenter = LatLng(50.0647, 19.9450);

  // Map bounds for camera constraint
  static LatLngBounds get krakowBounds => LatLngBounds(
        const LatLng(49.0, 19.0),
        const LatLng(51.0, 21.0),
      );

  // Zoom levels
  static const double initialZoom = 13.0;
  static const double minZoom = 8.0;
  static const double maxZoom = 18.0;
  static const double userLocationZoom = 15.0;
  static const double zoomStep = 1.0;

  // Map tiles
  static const String openStreetMapUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'com.journey_radar_mobile.app';
  static const List<String> tileSubdomains = ['a', 'b', 'c'];

  // Polyline styling
  static const double busRouteStrokeWidth = 4.0;

  // API limits
  static const int defaultMapPointsLimit = 50;
  static const int defaultBusRoutesLimit = 20;

  // Map rotation
  static const double northRotation = 0.0;
}
