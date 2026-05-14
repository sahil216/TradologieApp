import 'package:equatable/equatable.dart';

class ChatbotTranMessage extends Equatable {
  final int rowNum;
  final String msgType;
  final String msgFrom;
  final String responseText;
  final String userName;

  const ChatbotTranMessage({
    required this.rowNum,
    required this.msgType,
    required this.msgFrom,
    required this.responseText,
    required this.userName,
  });

  bool get isAi => msgFrom.toLowerCase() == 'aiagent';
  bool get isUser => !isAi;

  @override
  List<Object?> get props =>
      [rowNum, msgType, msgFrom, responseText, userName];
}
