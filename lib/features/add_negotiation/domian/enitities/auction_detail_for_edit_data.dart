import 'package:equatable/equatable.dart';

class AuctionDetailForEditData extends Equatable {
  final String? auctionCode;
  final String? auctionName;
  final String? status;
  final String? preferredDate;
  final String? startDate;
  final String? endDate;
  final int? deliveryAddressId;
  final int? agencyId;
  final String? agencyCompanyName;
  final String? deliveryAddress;
  final String? deliveryState;
  final String? portOfDischarge;
  final String? paymentTerm;
  final dynamic lcFileType;
  final String? lcFileUrl;
  final String? bankerName;
  final String? currencyId;
  final String? currencyName;
  final String? partialDelivery;
  final int? auctionId;
  final int? auctionGroupId;
  final String? totalQuantity;
  final String? minQuantity;
  final DateTime? deliveryLastDate;
  final String? agencyName;
  final String? agencyAddress;
  final String? agencyPhone;
  final String? agencyEmail;
  final String? remarks;
  final int? customerId;

  const AuctionDetailForEditData({
    this.auctionCode,
    this.auctionName,
    this.status,
    this.preferredDate,
    this.startDate,
    this.endDate,
    this.deliveryAddressId,
    this.agencyId,
    this.agencyCompanyName,
    this.deliveryAddress,
    this.deliveryState,
    this.portOfDischarge,
    this.paymentTerm,
    this.lcFileType,
    this.lcFileUrl,
    this.bankerName,
    this.currencyId,
    this.currencyName,
    this.partialDelivery,
    this.auctionId,
    this.auctionGroupId,
    this.totalQuantity,
    this.minQuantity,
    this.deliveryLastDate,
    this.agencyName,
    this.agencyAddress,
    this.agencyPhone,
    this.agencyEmail,
    this.remarks,
    this.customerId,
  });

  @override
  List<Object?> get props => [
        auctionCode,
        auctionName,
        status,
        preferredDate,
        startDate,
        endDate,
        deliveryAddressId,
        agencyId,
        agencyCompanyName,
        deliveryAddress,
        deliveryState,
        portOfDischarge,
        paymentTerm,
        lcFileType,
        lcFileUrl,
        bankerName,
        currencyId,
        currencyName,
        partialDelivery,
        auctionId,
        auctionGroupId,
        totalQuantity,
        minQuantity,
        deliveryLastDate,
        agencyName,
        agencyAddress,
        agencyPhone,
        agencyEmail,
        remarks,
        customerId,
      ];
}
