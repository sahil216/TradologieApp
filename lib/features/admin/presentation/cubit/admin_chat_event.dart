import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

abstract class AdminChatEvent extends Equatable {
  const AdminChatEvent();

  @override
  List<Object?> get props => [];
}

class AdminChatConnect extends AdminChatEvent {
  final String fromUserId;
  final String toUserId;
  final String apiCode;
  final String type1;
  final String type2;

  /// More Options → Connect: use fixed SendMessage targets (toUserId=1, etc.).
  final bool isConnectChat;

  const AdminChatConnect({
    required this.fromUserId,
    required this.toUserId,
    required this.apiCode,
    required this.type1,
    required this.type2,
    this.isConnectChat = false,
  });

  @override
  List<Object?> get props =>
      [fromUserId, toUserId, apiCode, type1, type2, isConnectChat];
}

class AdminChatDisconnect extends AdminChatEvent {
  const AdminChatDisconnect();
}

/// App background / inactive — tear down hub, keep messages for resume.
class AdminChatPause extends AdminChatEvent {
  const AdminChatPause();
}

/// App resumed while chat visible — reconnect hub without reloading history.
class AdminChatResume extends AdminChatEvent {
  const AdminChatResume();
}

class AdminChatSendText extends AdminChatEvent {
  final String text;

  const AdminChatSendText(this.text);

  @override
  List<Object?> get props => [text];
}

class AdminChatMessageReceived extends AdminChatEvent {
  final ChatMessage message;

  const AdminChatMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminChatConnectionChanged extends AdminChatEvent {
  final bool connected;

  const AdminChatConnectionChanged(this.connected);

  @override
  List<Object?> get props => [connected];
}
