import 'package:equatable/equatable.dart';

class DistributorEnquiryList extends Equatable {
  final int? quotationUserId;
  final String? userId;
  final String? name;
  final String? countryCode;
  final String? mobile;
  final String? email;
  final int? insertedId;
  final String? companyName;
  final String? interestedBrandName;
  final String? perferredLocation;
  final int? brandId;
  final DateTime? insertedDate;
  final int? updatedId;
  final DateTime? updatedDate;

  const DistributorEnquiryList({
    this.quotationUserId,
    this.userId,
    this.name,
    this.countryCode,
    this.mobile,
    this.email,
    this.insertedId,
    this.companyName,
    this.interestedBrandName,
    this.perferredLocation,
    this.brandId,
    this.insertedDate,
    this.updatedId,
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
        insertedId,
        companyName,
        interestedBrandName,
        perferredLocation,
        brandId,
        insertedDate,
        updatedId,
        updatedDate,
      ];
}
