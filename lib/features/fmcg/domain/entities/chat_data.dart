import 'package:equatable/equatable.dart';

class ChatData extends Equatable {
  final String? tranId;
  final String? chatId;
  final String? buyerId;
  final String? sellerId;
  final String? msgType;
  final String? msgContent;
  final String? insertedId;
  final String? insertedDate;
  final dynamic ipAddress;
  final String? displayDate;
  final String? displayTime;
  final String? isMessage;
  final String? attachmentType;
  final String? fileType;

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
    this.displayDate,
    this.displayTime,
    this.isMessage,
    this.attachmentType,
    this.fileType,
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
        ipAddress,
        displayDate,
        displayTime,
        isMessage,
        attachmentType,
        fileType,
      ];
}
