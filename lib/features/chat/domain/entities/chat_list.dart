import 'package:equatable/equatable.dart';

class ChatList extends Equatable {
  final String? quotationUserId;
  final String? userId;
  final String? name;
  final String? countryCode;
  final String? mobile;
  final String? email;
  final String? brandId;
  final String? brandName;
  final String? insertedDate;
  final String? updatedDate;

  const ChatList({
    this.quotationUserId,
    this.userId,
    this.name,
    this.countryCode,
    this.mobile,
    this.email,
    this.brandId,
    this.brandName,
    this.insertedDate,
    this.updatedDate,
  });

  @override
  List<Object?> get props => [
        quotationUserId,
        userId,
        name,
        countryCode,
        mobile,
        email,
        brandId,
        brandName,
        insertedDate,
        updatedDate,
      ];
}
