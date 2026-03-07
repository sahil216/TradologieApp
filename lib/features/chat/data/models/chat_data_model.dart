import 'dart:convert';

import 'package:tradologie_app/features/chat/domain/entities/chat_data.dart';

class ChatDataModel extends ChatData {
  const ChatDataModel({
    super.tranId,
    super.chatId,
    super.buyerId,
    super.sellerId,
    super.msgType,
    super.msgContent,
    super.insertedId,
    super.insertedDate,
    super.ipAddress,
  });

  factory ChatDataModel.fromJson(Map<String, dynamic> json) => ChatDataModel(
        tranId: json["TranID"],
        chatId: json["ChatID"],
        buyerId: json["BuyerID"],
        sellerId: json["SellerID"],
        msgType: json["MsgType"],
        msgContent: json["MsgContent"],
        insertedId: json["InsertedID"],
        insertedDate: json["InsertedDate"] == null
            ? null
            : DateTime.parse(json["InsertedDate"]),
        ipAddress: json["IPAddress"],
      );
}
