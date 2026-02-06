import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

typedef NotificationTapHandler = void Function(RemoteMessage message);

/// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("📩 Background message received: ${message.messageId}");
}

class FirebaseNotificationService {
  final NavigationService navigationService;
  final NotificationTapHandler? handler;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  FirebaseNotificationService({
    required this.navigationService,
    this.handler,
  });

  SecureStorageService storage = SecureStorageService();

  /// Initialize notification service
  Future<void> init() async {
    // Request permissions
    await _requestPermissions();

    // Initialize local notifications
    await _initLocalNotifications();

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_showNotification);

    // Tapped notifications (app opened from background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // FCM token
    final token = await _messaging.getToken();
    log("🔥 FCM Token: $token");
    storage.write(AppStrings.fcmToken, token ?? "");
  }

  /// Request notification permissions (iOS & Android 13+)
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

  /// Initialize local notification plugin
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

  /// Show a notification (foreground messages or local test)
  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return; // nothing to show

    const androidDetails = AndroidNotificationDetails(
      'default_channel', // channel id
      'General Notifications', // channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title ?? 'Notification',
      body: notification.body ?? '',
      notificationDetails: details,
      payload: message.data['route'],
    );
  }

  /// Handle tap from local notification
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload ?? '';
    final message = RemoteMessage(
      notification: RemoteNotification(title: 'Notification', body: payload),
      data: {'route': payload},
    );

    _handleMessageTap(message);
  }

  /// Handle tapped notification
  void _handleMessageTap(RemoteMessage message) {
    if (handler != null) {
      handler!(message);
    } else if (message.data.containsKey('route')) {
      navigationService.navigateTo(message.data['route']);
    }
  }

  /// Public helper: send a test notification (no backend needed)
  Future<void> sendTestNotification({
    String title = 'Test Notification',
    String body = 'This is a test notification!',
    String route = '/home',
  }) async {
    final message = RemoteMessage(
      notification: RemoteNotification(title: title, body: body),
      data: {'route': route},
    );
    await _showNotification(message);
  }
}
