import 'package:equatable/equatable.dart';

class ChatbotQueryListItem extends Equatable {
  final int rowNum;
  final int chatMainId;
  final String uid;
  final String optionText;
  final String ipAddress;
  final String name;
  final String email;
  final String mobile;
  final String annualTurnover;
  final String country;
  final String updatedDate;
  final String message;
  final String schedularDate;
  final int childCount;

  const ChatbotQueryListItem({
    required this.rowNum,
    required this.chatMainId,
    required this.uid,
    required this.optionText,
    required this.ipAddress,
    required this.name,
    required this.email,
    required this.mobile,
    required this.annualTurnover,
    required this.country,
    required this.updatedDate,
    required this.message,
    required this.schedularDate,
    required this.childCount,
  });

  @override
  List<Object?> get props => [
        rowNum,
        chatMainId,
        uid,
        optionText,
        ipAddress,
        name,
        email,
        mobile,
        annualTurnover,
        country,
        updatedDate,
        message,
        schedularDate,
        childCount,
      ];
}

class ChatbotQueryListResult extends Equatable {
  final List<ChatbotQueryListItem> items;
  final int totalPages;
  final int totalRecords;

  const ChatbotQueryListResult({
    required this.items,
    required this.totalPages,
    required this.totalRecords,
  });

  @override
  List<Object?> get props => [items, totalPages, totalRecords];
}
