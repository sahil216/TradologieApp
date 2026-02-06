import 'package:equatable/equatable.dart';

class NegotiationResult extends Equatable {
  final String? auctionId;
  final String? auctionCode;
  final String? auctionName;
  final String? customerId;
  final String? customerName;
  final String? totalQuantity;
  final String? minQuantity;
  final String? participateQuantity;
  final String? totalOrderQuantity;
  final String? poNo;
  final String? auctionCharge;
  final String? acceptanceStatus;
  final String? counterStatus;
  final String? orderStatus;
  final String? remarks;
  final bool? isStarted;
  final bool? isclosed;
  final String? deliveryLastDate;
  final String? startDate;
  final String? endDate;
  final String? preferredDate;
  final String? navigateUrl;
  final String? navigateViewUrl;
  final String? linkType;

  const NegotiationResult({
    this.auctionId,
    this.auctionCode,
    this.auctionName,
    this.customerId,
    this.customerName,
    this.totalQuantity,
    this.minQuantity,
    this.participateQuantity,
    this.totalOrderQuantity,
    this.poNo,
    this.auctionCharge,
    this.acceptanceStatus,
    this.counterStatus,
    this.orderStatus,
    this.remarks,
    this.isStarted,
    this.isclosed,
    this.deliveryLastDate,
    this.startDate,
    this.endDate,
    this.preferredDate,
    this.navigateUrl,
    this.navigateViewUrl,
    this.linkType,
  });

  @override
  List<Object?> get props => [
        auctionId,
        auctionCode,
        auctionName,
        customerId,
        customerName,
        totalQuantity,
        minQuantity,
        participateQuantity,
        totalOrderQuantity,
        poNo,
        auctionCharge,
        acceptanceStatus,
        counterStatus,
        orderStatus,
        remarks,
        isStarted,
        isclosed,
        deliveryLastDate,
        startDate,
        endDate,
        preferredDate,
        navigateUrl,
        navigateViewUrl,
        linkType
      ];
}
