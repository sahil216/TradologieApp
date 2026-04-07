import 'package:equatable/equatable.dart';

class ChatList extends Equatable {
  String? quotationUserId;
  String? sellerId;
  String? userId;
  String? name;
  String? countryCode;
  String? mobile;
  String? email;
  String? brandId;
  String? brandName;
  String? insertedDate;
  String? updatedDate;
  String? chatInsertedDate;
  String? loginStatus;
  bool? isReadMessage;
  String? profileImage;

  ChatList({
    this.quotationUserId,
    this.userId,
    this.sellerId,
    this.name,
    this.countryCode,
    this.mobile,
    this.email,
    this.brandId,
    this.brandName,
    this.insertedDate,
    this.updatedDate,
    this.chatInsertedDate,
    this.loginStatus,
    this.isReadMessage,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
        quotationUserId,
        userId,
        sellerId,
        name,
        countryCode,
        mobile,
        email,
        brandId,
        brandName,
        insertedDate,
        updatedDate,
        chatInsertedDate,
        loginStatus,
        isReadMessage,
        profileImage,
      ];
}
