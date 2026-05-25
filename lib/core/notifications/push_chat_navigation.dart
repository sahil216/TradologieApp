import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/notifications/push_chat_notification_payload.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_vendor_chat_args.dart';

/// Opens the correct chat screen from an FCM tap.
class PushChatNavigation {
  PushChatNavigation._();

  static void _log(String msg) {
    if (kDebugMode) {
      debugPrint('[PushChatNavigation] $msg');
    }
  }

  /// Returns `true` if navigation was handled (or queued).
  static bool tryNavigate(
    RemoteMessage message,
    NavigationService navigationService, {
    void Function(RemoteMessage message)? onDeferred,
  }) {
    final payload = PushChatNotificationPayload.tryParse(message.data);
    if (payload == null) {
      _log('not a chat push — keys=${message.data.keys.toList()}');
      return false;
    }

    _log('parsed type=${payload.type} fromId=${payload.fromId} name=${payload.name}');

    if (payload.isAdminChat) {
      return _openDedicatedSupportChat(navigationService, onDeferred, message);
    }

    if (payload.isAgroSellerChat) {
      return _openAgroSellerChat(payload, navigationService, onDeferred, message);
    }

    _log('unsupported chat type: ${payload.type}');
    return false;
  }

  /// Same screen as bottom-tab / More Options → Dedicated Support.
  static bool _openDedicatedSupportChat(
    NavigationService navigationService,
    void Function(RemoteMessage message)? onDeferred,
    RemoteMessage message,
  ) {
    if (Constants.isAdmin || Constants.isBuyer || Constants.isFmcg) {
      _log('AdminChat push ignored for role admin/buyer/fmcg');
      return false;
    }

    void push() {
      _log('navigating → ${Routes.adminDirectConnectChat}');
      navigationService.pushNamed(Routes.adminDirectConnectChat);
    }

    if (navigationService.navigationKey.currentState == null) {
      _log('navigator not ready — deferring AdminChat');
      onDeferred?.call(message);
      return true;
    }

    push();
    return true;
  }

  static bool _openAgroSellerChat(
    PushChatNotificationPayload payload,
    NavigationService navigationService,
    void Function(RemoteMessage message)? onDeferred,
    RemoteMessage message,
  ) {
    if (Constants.isAdmin) {
      void push() {
        _log('navigating → ${Routes.adminVendorChat}');
        navigationService.pushNamed(
          Routes.adminVendorChat,
          arguments: const AdminVendorChatArgs(
            categoryTitle: 'Connect with Agro Seller',
          ),
        );
      }

      if (navigationService.navigationKey.currentState == null) {
        _log('navigator not ready — deferring AgroSellerChat');
        onDeferred?.call(message);
        return true;
      }

      push();
      return true;
    }

    // Agro seller: open Dedicated Support (Connect) chat with admin.
    if (!Constants.isFmcg && !Constants.isBuyer) {
      return _openDedicatedSupportChat(navigationService, onDeferred, message);
    }

    return false;
  }
}
