import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/notifications/fcm_data_normalizer.dart';
import 'package:tradologie_app/core/notifications/push_chat_navigation.dart';
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

/// Prints long strings in chunks so nothing is truncated in the Flutter console.
void _debugPrintLong(String header, String body) {
  const chunkSize = 900;
  debugPrint('');
  debugPrint('╔══════════════════════════════════════════════════════════');
  debugPrint('║ $header');
  debugPrint('╠══════════════════════════════════════════════════════════');
  if (body.length <= chunkSize) {
    debugPrint(body);
  } else {
    for (var i = 0; i < body.length; i += chunkSize) {
      final end =
          i + chunkSize < body.length ? i + chunkSize : body.length;
      debugPrint(body.substring(i, end));
    }
  }
  debugPrint('╚══════════════════════════════════════════════════════════');
  debugPrint('');
}

/// Logs the full FCM [RemoteMessage] (data + notification + metadata).
void logPushNotificationPayload(String source, RemoteMessage message) {
  try {
    final payload = _toJsonSafe(_remoteMessageToJson(message));
    final jsonText = _jsonEncoder.convert(payload);

    _debugPrintLong('📩 FCM push [$source]', jsonText);

    developer.log(
      'FCM push [$source] (${jsonText.length} chars)',
      name: 'FCM',
    );
  } catch (e, st) {
    _debugPrintLong(
      '📩 FCM push [$source] — serialize error',
      '$e\n\n$st\n\nmessage.toString():\n$message',
    );
  }
}

Map<String, dynamic> _remoteMessageToJson(RemoteMessage message) {
  final notification = message.notification;

  final data = Map<String, dynamic>.from(message.data);
  final parsedData = <String, dynamic>{};
  for (final entry in data.entries) {
    final key = entry.key;
    final raw = entry.value;
    parsedData[key] = raw;
    final trimmed = raw.trim();
    if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
      try {
        parsedData['${key}__parsed'] = jsonDecode(trimmed);
      } catch (_) {
        // Keep string only.
      }
    }
  }

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
    'data': data,
    'data_parsed': parsedData,
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
                    'priority': notification.android!.priority?.name,
                    'smallIcon': notification.android!.smallIcon,
                    'sound': notification.android!.sound,
                    'ticker': notification.android!.ticker,
                    'visibility': notification.android!.visibility?.name,
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

  RemoteMessage? _pendingChatTap;
  bool _pendingNavigationScheduled = false;

  /// True after splash/main (or admin home) has replaced the initial route.
  bool _appShellReady = false;

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
      unawaited(_handleMessageTap(message));
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
      _deferMessageTap(initialMessage);
    } else {
      debugPrint('[FCM] No initial message (app not opened from notification)');
    }

    final token = await _messaging.getToken();
    debugPrint('🔥 FCM Token: $token');
    storage.write(AppStrings.fcmToken, token ?? '');

    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('🔥 FCM Token refreshed: $newToken');
      storage.write(AppStrings.fcmToken, newToken);
    });
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

    debugPrint(
      '[FCM] permission: ${settings.authorizationStatus.name}',
    );
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

    if (notification == null) {
      debugPrint(
        '[FCM] Data-only message (no notification block) — data keys: ${message.data.keys.toList()}',
      );
      return;
    }

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
      payload: jsonEncode(message.data),
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    _debugPrintLong(
      '📩 FCM local notification tap',
      _jsonEncoder.convert(_toJsonSafe({
        'id': response.id,
        'actionId': response.actionId,
        'input': response.input,
        'payload': response.payload,
        'notificationResponseType':
            response.notificationResponseType.name,
      })),
    );

    final raw = response.payload ?? '';
    Map<String, dynamic> data = {};
    if (raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          data = decoded.map(
            (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
          );
        }
      } catch (_) {
        if (raw.startsWith('/')) {
          data = {'route': raw};
        }
      }
    }

    unawaited(_handleMessageTap(RemoteMessage(data: data)));
  }

  /// Call from [MainScreen] / admin home after login shell is visible.
  void markAppShellReady() {
    if (_appShellReady) {
      processPendingNavigation();
      return;
    }
    _appShellReady = true;
    debugPrint('[FCM] app shell ready — processing pending notification');
    processPendingNavigation();
  }

  bool get _canNavigateToChat =>
      _appShellReady && navigationService.navigationKey.currentState != null;

  /// Call once main route is active (e.g. after splash on cold start).
  void processPendingNavigation() {
    final pending = _pendingChatTap;
    if (pending == null) return;

    if (!_canNavigateToChat) {
      debugPrint('[FCM] pending chat nav — waiting for app shell');
      schedulePendingNavigation();
      return;
    }

    _pendingChatTap = null;
    unawaited(_handleMessageTap(pending));
  }

  void schedulePendingNavigation() {
    if (_pendingChatTap == null || _pendingNavigationScheduled) return;
    _pendingNavigationScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _pendingNavigationScheduled = false;
      processPendingNavigation();
    });
  }

  void _deferMessageTap(RemoteMessage message) {
    _pendingChatTap = message;
    schedulePendingNavigation();
  }

  RemoteMessage _normalizeMessage(RemoteMessage message) {
    final data = normalizeFcmData(Map<String, dynamic>.from(message.data));
    return RemoteMessage(
      messageId: message.messageId,
      data: data,
      notification: message.notification,
    );
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    final normalized = _normalizeMessage(message);
    debugPrint('[FCM] handleMessageTap data=${normalized.data}');

    if (!_canNavigateToChat) {
      debugPrint('[FCM] deferring chat tap until app shell is ready');
      _deferMessageTap(normalized);
      return;
    }

    await badgeService.clear();

    final handled = PushChatNavigation.tryNavigate(
      normalized,
      navigationService,
      onDeferred: _deferMessageTap,
    );
    if (handled) return;

    final route = normalized.data['route'];
    if (route != null && route.isNotEmpty) {
      navigationService.navigateTo(route);
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
    logPushNotificationPayload('test_local', message);
    await badgeService.increment();
    await _showNotification(message);
  }
}
