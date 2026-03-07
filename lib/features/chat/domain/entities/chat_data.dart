import 'package:equatable/equatable.dart';

class ChatData extends Equatable {
  final int? tranId;
  final int? chatId;
  final int? buyerId;
  final int? sellerId;
  final String? msgType;
  final String? msgContent;
  final String? insertedId;
  final DateTime? insertedDate;
  final dynamic ipAddress;

  const ChatData({
    this.tranId,
    this.chatId,
    this.buyerId,
    this.sellerId,
    this.msgType,
    this.msgContent,
    this.insertedId,
    this.insertedDate,
    this.ipAddress,
  });

  @override
  List<Object?> get props => [
        tranId,
        chatId,
        buyerId,
        sellerId,
        msgType,
        msgContent,
        insertedId,
        insertedDate,
        ipAddress
      ];
}
