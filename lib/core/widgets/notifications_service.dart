import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/notification_badge_service.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

const _jsonEncoder = JsonEncoder.withIndent('  ');

/// Recursively converts values to JSON-safe primitives (enums → name, etc.).
dynamic _toJsonSafe(dynamic value) {
  if (value == null) return null;
  if (value is String || value is num || value is bool) return value;
  if (value is DateTime) return value.toIso8601String();
  if (value is Enum) return value.name;
  if (value is Map) {
    return value.map(
      (key, val) => MapEntry(key.toString(), _toJsonSafe(val)),
    );
  }
  if (value is Iterable) {
    return value.map(_toJsonSafe).toList();
  }
  return value.toString();
}

/// Logs the full FCM payload as formatted JSON (debug / console).
void logPushNotificationPayload(String source, RemoteMessage message) {
  try {
    final payload = _toJsonSafe(_remoteMessageToJson(message));
    log(
      '📩 Push notification [$source]\n${_jsonEncoder.convert(payload)}',
      name: 'FCM',
    );
  } catch (e, st) {
    log(
      '📩 Push notification [$source] (serialize error: $e)\n$st',
      name: 'FCM',
    );
  }
}

Map<String, dynamic> _remoteMessageToJson(RemoteMessage message) {
  final notification = message.notification;
  return {
    'messageId': message.messageId,
    'senderId': message.senderId,
    'from': message.from,
    'category': message.category,
    'collapseKey': message.collapseKey,
    'contentAvailable': message.contentAvailable,
    'messageType': message.messageType,
    'mutableContent': message.mutableContent,
    'sentTime': message.sentTime?.toIso8601String(),
    'threadId': message.threadId,
    'ttl': message.ttl,
    'data': Map<String, dynamic>.from(message.data),
    'notification': notification == null
        ? null
        : {
            'title': notification.title,
            'body': notification.body,
            'titleLocKey': notification.titleLocKey,
            'titleLocArgs': notification.titleLocArgs,
            'bodyLocKey': notification.bodyLocKey,
            'bodyLocArgs': notification.bodyLocArgs,
            'android': notification.android == null
                ? null
                : {
                    'channelId': notification.android!.channelId,
                    'clickAction': notification.android!.clickAction,
                    'color': notification.android!.color,
                    'count': notification.android!.count,
                    'imageUrl': notification.android!.imageUrl,
                    'link': notification.android!.link,
                    'priority': notification.android!.priority,
                    'smallIcon': notification.android!.smallIcon,
                    'sound': notification.android!.sound,
                    'ticker': notification.android!.ticker,
                    'visibility': notification.android!.visibility,
                  },
            'apple': notification.apple == null
                ? null
                : {
                    'badge': notification.apple!.badge,
                    'imageUrl': notification.apple!.imageUrl,
                    'sound': notification.apple!.sound,
                    'subtitle': notification.apple!.subtitle,
                  },
          },
  };
}

/// Background message handler (must be top-level).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  logPushNotificationPayload('background', message);
  await NotificationBadgeService.incrementInBackground();
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
      logPushNotificationPayload('foreground', message);
      await badgeService.increment();
      await _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      logPushNotificationPayload('opened_from_background', message);
      _handleMessageTap(message);
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      logPushNotificationPayload('opened_from_terminated', initialMessage);
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
    log(
      '📩 Push notification [local_tap]\n${_jsonEncoder.convert({
        'id': response.id,
        'actionId': response.actionId,
        'input': response.input,
        'payload': response.payload,
        'notificationResponseType':
            response.notificationResponseType.name,
      })}',
      name: 'FCM',
    );

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
