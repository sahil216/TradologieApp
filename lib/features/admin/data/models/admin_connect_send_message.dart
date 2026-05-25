import 'package:tradologie_app/features/admin/data/models/admin_message_info.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';

/// SignalR hub: `SendMessage(fromUserId, toUserId, ApiCode, Type1, Type2, MessageInfo)`
/// Vendor Connect flow (More Options).
class AdminConnectSendMessage {
  static const String toUserId = AdminConnectChatConfig.toUserId;
  static const String type1 = AdminConnectChatConfig.type1;
  static const String type2 = AdminConnectChatConfig.type2;

  final String fromUserId;
  final String apiCode;
  final AdminMessageInfo messageInfo;

  const AdminConnectSendMessage({
    required this.fromUserId,
    required this.apiCode,
    required this.messageInfo,
  });

  List<Object> toHubArgs() => [
        fromUserId,
        toUserId,
        apiCode,
        type1,
        type2,
        messageInfo.toJson(),
      ];
}
