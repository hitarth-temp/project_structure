import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../api/api_constant.dart';
import '../core/utils/app_logger.dart';
import '../repository/local_repository/local_repository.dart';

/// Enum for App States
enum AppState { foreground, background, terminated }

/// Enum for Notification Type
enum NotificationType { sync, unknown }

class MyNotificationManager {
  MyNotificationManager._();

  static final MyNotificationManager _instance = MyNotificationManager._();

  factory MyNotificationManager() => _instance;

  late AndroidNotificationChannel _channel;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  NotificationSettings? _settings;
  RemoteMessage? _remoteMessage;

  Future<void> init() async {
    await _requestNotificationPermission();
    _initializeLocalNotifications();
    _setupFirebaseListeners();
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    _settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (_settings?.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      if (token != null) {
        await Get.find<LocalRepositoryImpl>()
            .setData(LocalStorageKey.deviceToken, token);
        ApiConstant.firebaseToken = token;
        logger.i('FCM Token: $token');
      }
    } else {
      logger.w('User denied notification permissions.');
    }
  }

  /// Initialize local notification plugin
  void _initializeLocalNotifications() {
    _channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        logger.i("Notification tapped: ${_remoteMessage?.data}");
        if (_remoteMessage != null) {
          _handleNotificationClick(_remoteMessage!, AppState.foreground);
        }
      },
    );

    if (!kIsWeb) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
  }

  /// Setup Firebase Messaging listeners
  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _remoteMessage = message;
      _handleForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message, AppState.background);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationClick(message, AppState.terminated);
      }
    });
  }

  /// Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    logger.i("Handling background message: ${message.messageId}");
  }

  /// Handle notification in foreground
  void _handleForegroundNotification(RemoteMessage message) {
    logger.i("Foreground notification: ${jsonEncode(message.data)}");

    RemoteNotification? notification = message.notification;
    if (notification != null) {
      _showNotification(notification, message.data);
    }
  }

  /// Show local notification
  void _showNotification(
    RemoteNotification notification,
    Map<String, dynamic> data,
  ) {
    _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          styleInformation: BigTextStyleInformation(notification.body ?? ""),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          subtitle: notification.body,
          presentSound: true,
        ),
      ),
    );
  }

  /// Handle notification click
  void _handleNotificationClick(RemoteMessage message, AppState appState) {
    final type = _getNotificationType(message.data['type']);
    logger.i("Notification clicked: type=$type, state=$appState");

    switch (type) {
      case NotificationType.sync:
        _performSyncTask(message.data);
        break;
      default:
        logger.w("Unknown notification type");
    }
  }

  /// Get notification type from data
  NotificationType _getNotificationType(String? type) {
    switch (type) {
      case 'sync':
        return NotificationType.sync;
      default:
        return NotificationType.unknown;
    }
  }

  /// Perform a background sync task
  void _performSyncTask(Map<String, dynamic> data) {
    logger.i("Performing sync task with data: $data");
    // Implement your sync logic here
  }
}
