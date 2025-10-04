// ignore_for_file: unnecessary_lambdas

import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:go_router/go_router.dart';
import 'package:journey_radar_mobile/config/constants.dart';
import 'package:journey_radar_mobile/config/logger.dart';

/// A service responsible for handling Firebase Cloud Messaging (FCM)
/// and local notification interactions.
class FirebasePushNotificationService {
  FirebasePushNotificationService() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  late final FirebaseMessaging _firebaseMessaging;
  late final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final Set<String> _processedMessageIds = {};

  /// Keeps track of the currently subscribed FCM topic.
  String? _currentTopic;

  /// Retrieves the FCM token for the device.
  Future<String?> getFCMToken() async {
    final fCMToken = await _firebaseMessaging.getToken();
    logD('FCM Token: $fCMToken');
    return fCMToken;
  }

  /// Deletes the current FCM token.
  Future<void> deleteFCMToken() async {
    await _firebaseMessaging.deleteToken();
  }

  /// Initializes FCM notifications (permissions, channels, and listeners).
  ///
  /// This method should be called once
  @pragma('vm:entry-point')
  Future<void> initNotifications({
    required BuildContext context,
    required String languageCode,
  }) async {
    // Request FCM permissions first
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logD(
        'User granted permission: ${notificationSettings.authorizationStatus}');

    // Local notifications plugin initialization for Android.
    const androidInit = AndroidInitializationSettings(
        AppConstants.nativeAndroidDefaultIconPath);
    const initSettings = InitializationSettings(
      android: androidInit,
    );

    // Subscribes the current device to the FCM topic that matches the user's languageCode.
    // This ensures the device will receive notifications that target this particular topic.
    await subscribeToTopic(languageCode: languageCode);

    // Initializes the local notifications plugin so that your app can
    // display local push notifications (e.g., in the foreground).
    // The `onDidReceiveNotificationResponse` callback lets you handle what happens when
    // the user taps or interacts with a displayed notification.
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) => _onNotificationTap(
        response: response,
        context: context,
        languageCode: languageCode,
      ),
    );

    // Requests permission for iOS to display alerts, badges, sounds, and so on.
    // If provisional is true, the user can receive "provisional" or "quiet" notifications
    // without having to explicitly allow them first. If critical is true, you can also send
    // critical alerts that can bypass Do Not Disturb settings.
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          provisional: true,
          critical: true,
        );

    // For iOS, this configures how notifications should be presented when your app is
    // in the foreground. Here, we make it match `Platform.isAndroid` for alert, and always
    // enable badge and sound. Setting `alert` to false would suppress the system’s native
    // banner, leaving you to display a custom notification if desired.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: Platform.isAndroid,
      badge: true,
      sound: true,
    );

    // Handle messages while the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (context.mounted) {
        // Check if the message ID already exists in the set of processed messages to prevent double notification
        if (_processedMessageIds.contains(message.messageId)) {
          return;
        }
        // If the message ID is not in the set, add it to mark this message as processed.
        _processedMessageIds.add(message.messageId!);
        _showNotification(
          message: message,
          context: context,
          languageCode: languageCode,
        );
      }
    });

    // Handle notification taps that bring the app from background to foreground.
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      logD('Notification clicked: $message, ${message.notification}');
      if (context.mounted) {
        await _handleMessageOpenedApp(
          message: message,
          context: context,
          languageCode: languageCode,
        );
      }
    });

    // Handle notification taps that bring the app from terminated to foreground.
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    logD('Notification clicked from terminated app:');
    if (initialMessage != null) {
      if (context.mounted) {
        await _handleMessageOpenedApp(
          message: initialMessage,
          context: context,
          languageCode: languageCode,
        );
      }
    }
  }

  /// Subscribes to a particular topic (e.g., language-based).
  ///
  /// If already subscribed to a previous topic, unsubscribes first.
  Future<void> subscribeToTopic({
    required String languageCode,
  }) async {
    if (_currentTopic != null) {
      await _firebaseMessaging.unsubscribeFromTopic(_currentTopic!);
    }
    _currentTopic = languageCode;
    await _firebaseMessaging.subscribeToTopic(languageCode);
    logD('Subscribed to topic: $languageCode');
  }

  /// Subscribes to a specific route topic for incident notifications
  Future<void> subscribeToRouteTopic({
    required String routeId,
  }) async {
    final topicName = 'route_$routeId';
    await _firebaseMessaging.subscribeToTopic(topicName);
    logD('Subscribed to route topic: $topicName');
  }

  /// Unsubscribes from a specific route topic
  Future<void> unsubscribeFromRouteTopic({
    required String routeId,
  }) async {
    final topicName = 'route_$routeId';
    await _firebaseMessaging.unsubscribeFromTopic(topicName);
    logD('Unsubscribed from route topic: $topicName');
  }

  /// Sends an incident notification to users on a specific route
  /// This is a mock implementation - in a real app, this would call your backend API
  Future<void> sendIncidentNotification({
    required String routeId,
    required String incidentType,
    required String incidentDescription,
    required String location,
    required bool isEmergency,
    String? station,
    Map<String, double>? gpsCoordinates,
  }) async {
    try {
      // Mock notification data - in a real implementation, this would be sent via your backend
      final notificationData = {
        'title': isEmergency ? '🚨 PILNY INCYDENT' : '⚠️ Nowy incydent',
        'body': '$incidentType - $location',
        'data': {
          'type': 'incident',
          'incidentType': incidentType,
          'routeId': routeId,
          'location': location,
          'station': station ?? '',
          'isEmergency': isEmergency.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          'description': incidentDescription,
          'gpsCoordinates': gpsCoordinates != null
              ? {
                  'latitude': gpsCoordinates['latitude'],
                  'longitude': gpsCoordinates['longitude'],
                }
              : null,
        },
      };

      logD('Sending incident notification: $notificationData');

      // In a real implementation, you would:
      // 1. Call your backend API to send the notification
      // 2. The backend would use Firebase Admin SDK to send to the route topic
      // 3. Users subscribed to that route topic would receive the notification

      // For now, we'll simulate this by showing a local notification
      await _showLocalIncidentNotification(notificationData);
    } catch (e) {
      logD('Error sending incident notification: $e');
      rethrow;
    }
  }

  /// Shows a local notification for incident reporting (for testing purposes)
  Future<void> _showLocalIncidentNotification(
      Map<String, dynamic> notificationData) async {
    const androidDetails = AndroidNotificationDetails(
      'incident_channel',
      'Incident Notifications',
      channelDescription: 'Notifications about incidents on routes',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      color: Colors.red,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      notificationData['title'],
      notificationData['body'],
      notificationDetails,
      payload: notificationData['data'].toString(),
    );
  }

  /// Displays a local notification when an FCM message arrives
  /// and optionally performs TTS.
  Future<void> _showNotification({
    required RemoteMessage message,
    required BuildContext context,
    required String languageCode,
  }) async {
    final notification = message.notification;

    if (notification == null) {
      return;
    }

    // Speak the notification body.
    if (notification.body != null && notification.body!.isNotEmpty) {
      final textToSpeech = FlutterTts();
      await textToSpeech.setLanguage(languageCode);
      unawaited(textToSpeech.speak(notification.body!));
    }

    // Prepare the local notification details.
    const androidDetails = AndroidNotificationDetails(
      AppConstants.androidPushNotificationsChannelId,
      AppConstants.androidPushNotificationsChannelName,
      channelDescription:
          AppConstants.androidPushNotificationsChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    // Combine them into a single platform-agnostic object
    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Show the local notification.
    await _localNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  /// Handles a notification tap from the system tray (while app is in foreground).
  Future<void> _onNotificationTap({
    required NotificationResponse response,
    required BuildContext context,
    required String languageCode,
  }) async {
    logD(
      'Notification tapped: '
      'payload=${response.payload}, '
      'input=${response.input}, '
      'type=${response.notificationResponseType}',
    );

    if (response.payload == null) return;
  }

  /// Handles logic when the app is opened from a push notification tap
  /// while the app is in background or terminated.
  Future<void> _handleMessageOpenedApp({
    required RemoteMessage message,
    required BuildContext context,
    required String languageCode,
  }) async {
    final notification = message.notification;

    // Speak if there's a body.
    if (notification?.body != null) {
      final textToSpeech = FlutterTts();
      await textToSpeech.setLanguage(languageCode);
      unawaited(textToSpeech.speak(notification!.body!));

      /* context.read<SendCommandCubit>().resetStateAndStopTalking();
      context.read<VoiceRecordingCubit>().resetState();
      unawaited(
        context.read<SendCommandCubit>().speakSomeText(
              languageCode: languageCode,
              speakText: notification!.body!,
            ),
      ); */
    }
  }
}
