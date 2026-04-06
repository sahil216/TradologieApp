import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';

class ChatListModel extends ChatList {
  ChatListModel({
    super.quotationUserId,
    super.sellerId,
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
    super.loginStatus,
    super.isReadMessage,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        quotationUserId: json["QuotationUserID"].toString(),
        userId: json["UserID"].toString(),
        sellerId: json["SellerID"].toString(),
        name: json["Name"].toString(),
        countryCode: json["CountryCode"].toString(),
        mobile: json["Mobile"].toString(),
        email: json["Email"].toString(),
        brandId: json["BrandID"].toString(),
        brandName: json["BrandName"].toString(),
        insertedDate: json["InsertedDate"].toString(),
        updatedDate: json["UpdatedDate"].toString(),
        chatInsertedDate: json["ChatInsertedDate"].toString(),
        loginStatus: json["LoginStatus"].toString(),
        isReadMessage: json["IsReadMsg"],
      );
}
