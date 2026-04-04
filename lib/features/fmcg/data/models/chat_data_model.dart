import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';

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
    super.displayDate,
    super.displayTime,
    super.isMessage,
    super.attachmentType,
    super.fileType,
  });

  factory ChatDataModel.fromJson(Map<String, dynamic> json) => ChatDataModel(
        tranId: json["TranID"].toString(),
        chatId: json["ChatID"].toString(),
        buyerId: json["BuyerID"].toString(),
        sellerId: json["SellerID"].toString(),
        msgType: json["MsgType"].toString(),
        msgContent: json["MsgContent"].toString(),
        insertedId: json["InsertedID"].toString(),
        insertedDate: json["InsertedDate"].toString(),
        ipAddress: json["IPAddress"].toString(),
        displayDate: json["DisplayDate"],
        displayTime: json["DisplayTime"],
        isMessage: json["IsMessage"],
        attachmentType: json["AttachmentType"].toString(),
        fileType: json["FileType"].toString(),
      );
}
