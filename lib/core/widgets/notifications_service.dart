import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/notification_badge_service.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

/// Background message handler (must be top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationBadgeService.incrementInBackground();
  log("📩 Background message received: ${message.messageId}");
}

class FirebaseNotificationService {
  final NavigationService navigationService;
  final NotificationBadgeService badgeService;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FirebaseNotificationService({
    required this.navigationService,
    required this.badgeService,
  });

  SecureStorageService storage = SecureStorageService();

  /// Initialize notification service
  Future<void> init() async {
    await _requestPermissions();
    await _initLocalNotifications();
    await badgeService.syncFromStorage();

    FirebaseMessaging.onMessage.listen((message) async {
      await badgeService.increment();
      await _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessageTap(initialMessage);
    }

    final token = await _messaging.getToken();
    log("🔥 FCM Token: $token");
    storage.write(AppStrings.fcmToken, token ?? "");
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("✅ Notification permission granted");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("ℹ️ Provisional permission granted");
    } else {
      log("❌ Notification permission denied");
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(
          android: androidSettings, iOS: initializationSettingsIOS),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails(
      badgeNumber: badgeService.count,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title ?? 'Notification',
      body: notification.body ?? '',
      notificationDetails: details,
      payload: message.data['route'],
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload ?? '';
    final message = RemoteMessage(
      notification: RemoteNotification(title: 'Notification', body: payload),
      data: {'route': payload},
    );

    _handleMessageTap(message);
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    await badgeService.clear();

    if (message.data.containsKey('route')) {
      navigationService.navigateTo(message.data['route']);
    }
  }

  Future<void> sendTestNotification({
    String title = 'Test Notification',
    String body = 'This is a test notification!',
    String route = '/home',
  }) async {
    final message = RemoteMessage(
      notification: RemoteNotification(title: title, body: body),
      data: {'route': route},
    );
    await badgeService.increment();
    await _showNotification(message);
  }
}
