import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_tran_message.dart';

class ChatbotTranMessageModel extends ChatbotTranMessage {
  const ChatbotTranMessageModel({
    required super.rowNum,
    required super.msgType,
    required super.msgFrom,
    required super.responseText,
    required super.userName,
  });

  factory ChatbotTranMessageModel.fromJson(Map<String, dynamic> json) {
    int row(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return ChatbotTranMessageModel(
      rowNum: row(json['RowNum']),
      msgType: json['MsgType']?.toString() ?? '',
      msgFrom: json['MsgFrom']?.toString() ?? '',
      responseText: json['ResponseText']?.toString() ?? '',
      userName: json['UserName']?.toString() ?? '',
    );
  }
}
