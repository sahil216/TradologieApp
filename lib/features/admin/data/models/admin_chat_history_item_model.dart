import 'package:tradologie_app/features/admin/domain/entities/admin_chat_history_item.dart';

class AdminChatHistoryItemModel extends AdminChatHistoryItem {
  const AdminChatHistoryItemModel({
    required super.msgFrom,
    required super.msgContent,
    required super.insertedDate,
  });

  factory AdminChatHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return AdminChatHistoryItemModel(
      msgFrom: json['msgFrom']?.toString() ?? '',
      msgContent: json['msgContent']?.toString() ?? '',
      insertedDate: json['insertedDate']?.toString() ?? '',
    );
  }
}
