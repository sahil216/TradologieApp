import 'package:equatable/equatable.dart';

class AdminChatHistoryItem extends Equatable {
  final String msgFrom;
  final String msgContent;
  final String insertedDate;

  const AdminChatHistoryItem({
    required this.msgFrom,
    required this.msgContent,
    required this.insertedDate,
  });

  @override
  List<Object?> get props => [msgFrom, msgContent, insertedDate];
}
