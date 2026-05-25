import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';

/// Parsed FCM `data` payload for admin ↔ agro seller chat.
class PushChatNotificationPayload {  final String type;
  final String name;
  final String fromId;
  final String message;
  final String title;

  const PushChatNotificationPayload({
    required this.type,
    required this.name,
    required this.fromId,
    this.message = '',
    this.title = '',
  });

  String get _normalizedType =>
      type.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');

  bool get isAgroSellerChat => _normalizedType == 'agrosellerchat';

  /// Vendor Dedicated Support / Connect chat with admin (Tradologie).
  bool get isAdminChat => _normalizedType == 'adminchat';

  /// Reads FCM [data] (keys may vary in casing).
  static PushChatNotificationPayload? tryParse(Map<String, dynamic> data) {
    if (data.isEmpty) return null;

    final normalized = <String, String>{};
    for (final entry in data.entries) {
      normalized[entry.key.toLowerCase()] = entry.value?.toString() ?? '';
    }

    final type = normalized['type'] ?? '';
    if (type.isEmpty) return null;

    final normalizedType =
        type.toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');

    var fromId = normalized['fromid'] ??
        normalized['from_id'] ??
        normalized['fromuserid'] ??
        normalized['touserid'] ??
        '';

    if (fromId.isEmpty && normalizedType == 'adminchat') {
      fromId = AdminConnectChatConfig.toUserId;
    }

    if (fromId.isEmpty && normalizedType != 'adminchat') {
      return null;
    }

    final name = normalized['name'] ??
        normalized['vendorname'] ??
        normalized['title'] ??
        '';

    return PushChatNotificationPayload(
      type: type,
      name: name.trim(),
      fromId: fromId.trim(),
      message: normalized['message'] ?? '',
      title: normalized['title'] ?? '',
    );
  }
}
