import 'package:tradologie_app/features/chat/domain/entities/chat_list.dart';

class ChatListModel extends ChatList {
  const ChatListModel({
    super.quotationUserId,
    super.userId,
    super.name,
    super.countryCode,
    super.mobile,
    super.email,
    super.brandId,
    super.brandName,
    super.insertedDate,
    super.updatedDate,
    super.chatInsertedDate,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        quotationUserId: json["QuotationUserID"].toString(),
        userId: json["UserID"].toString(),
        name: json["Name"].toString(),
        countryCode: json["CountryCode"].toString(),
        mobile: json["Mobile"].toString(),
        email: json["Email"].toString(),
        brandId: json["BrandID"].toString(),
        brandName: json["BrandName"].toString(),
        insertedDate: json["InsertedDate"].toString(),
        updatedDate: json["UpdatedDate"].toString(),
        chatInsertedDate: json["ChatInsertedDate"].toString(),
      );
}
