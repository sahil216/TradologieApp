import 'package:equatable/equatable.dart';

class DashboardResult extends Equatable {
  final String? auctionId;
  final String? customerId;
  final String? auctionGroupId;
  final String? auctionCode;
  final String? auctionName;
  final String? deliveryAddressId;
  final String? deliveryAddress;
  final String? deliveryState;
  final String? portOfDischarge;
  final String? paymentTerm;
  final String? lcFileType;
  final String? bankerName;
  final String? partialDelivery;
  final String? preferredDate;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? totalQuantity;
  final String? minQuantity;
  final String? deliveryLastDate;
  final String? remarks;
  final String? currencyId;
  final String? inspectionAgencyId;
  final String? agencyName;
  final String? agencyAddress;
  final String? agencyPhone;
  final String? agencyEmail;
  final String? companyName;
  final String? companyAddress;
  final String? areaId;
  final String? companyPhone;
  final String? companyEmail;
  final String? buyerAuctionCharges;
  final String? currencyCode;
  final String? currencyName;
  final String? groupName;
  final String? unit;
  final String? attributeValue1;
  final String? attributeValue2;
  final String? attributeName1;
  final String? attributeName2;

  const DashboardResult({
    this.auctionId,
    this.customerId,
    this.auctionGroupId,
    this.auctionCode,
    this.auctionName,
    this.deliveryAddressId,
    this.deliveryAddress,
    this.deliveryState,
    this.portOfDischarge,
    this.paymentTerm,
    this.lcFileType,
    this.bankerName,
    this.partialDelivery,
    this.preferredDate,
    this.startDate,
    this.endDate,
    this.status,
    this.totalQuantity,
    this.minQuantity,
    this.deliveryLastDate,
    this.remarks,
    this.currencyId,
    this.inspectionAgencyId,
    this.agencyName,
    this.agencyAddress,
    this.agencyPhone,
    this.agencyEmail,
    this.companyName,
    this.companyAddress,
    this.areaId,
    this.companyPhone,
    this.companyEmail,
    this.buyerAuctionCharges,
    this.currencyCode,
    this.currencyName,
    this.groupName,
    this.unit,
    this.attributeValue1,
    this.attributeValue2,
    this.attributeName1,
    this.attributeName2,
  });

  @override
  List<Object?> get props => [
        auctionId,
        customerId,
        auctionGroupId,
        auctionCode,
        auctionName,
        deliveryAddressId,
        deliveryAddress,
        deliveryState,
        portOfDischarge,
        paymentTerm,
        lcFileType,
        bankerName,
        partialDelivery,
        preferredDate,
        startDate,
        endDate,
        status,
        totalQuantity,
        minQuantity,
        deliveryLastDate,
        remarks,
        currencyId,
        inspectionAgencyId,
        agencyName,
        agencyAddress,
        agencyPhone,
        agencyEmail,
        companyName,
        companyAddress,
        areaId,
        companyPhone,
        companyEmail,
        buyerAuctionCharges,
        currencyCode,
        currencyName,
        groupName,
        unit,
        attributeValue1,
        attributeValue2,
        attributeName1,
        attributeName2,
      ];
}
