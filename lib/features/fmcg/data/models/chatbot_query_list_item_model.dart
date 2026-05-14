import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_query_list_item.dart';

class ChatbotQueryListItemModel extends ChatbotQueryListItem {
  const ChatbotQueryListItemModel({
    required super.rowNum,
    required super.chatMainId,
    required super.uid,
    required super.optionText,
    required super.ipAddress,
    required super.name,
    required super.email,
    required super.mobile,
    required super.annualTurnover,
    required super.country,
    required super.updatedDate,
    required super.message,
    required super.schedularDate,
    required super.childCount,
  });

  factory ChatbotQueryListItemModel.fromJson(Map<String, dynamic> json) {
    int _int(dynamic v) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return ChatbotQueryListItemModel(
      rowNum: _int(json['RowNum']),
      chatMainId: _int(json['ChatMainID']),
      uid: json['UID']?.toString() ?? '',
      optionText: json['OptionText']?.toString() ?? '',
      ipAddress: json['IPAddress']?.toString() ?? '',
      name: json['Name']?.toString() ?? '',
      email: json['Email']?.toString() ?? '',
      mobile: json['Mobile']?.toString() ?? '',
      annualTurnover: json['AnnualTurnover']?.toString() ?? '',
      country: json['Country']?.toString() ?? '',
      updatedDate: json['UpdatedDate']?.toString() ?? '',
      message: json['Message']?.toString() ?? '',
      schedularDate: json['SchedularDate']?.toString() ?? '',
      childCount: _int(json['ChildCount']),
    );
  }
}
