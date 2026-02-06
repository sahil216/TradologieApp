import 'package:equatable/equatable.dart';

class BuyerNegotiationDetail extends Equatable {
  final int? customerId;
  final int? auctionId;
  final String? auctionCode;
  final String? auctionName;
  final String? deliveryAddress;
  final String? deliveryState;
  final String? paymentTerm;
  final String? partialDelivery;
  final String? status;
  final bool? isStarted;
  final bool? isclosed;
  final String? startDate;
  final String? endDate;
  final String? preferredDate;
  final String? auctionUrl;
  final String? auctionStatus;
  final String? auctionCodeUrl;
  final String? auctionColorCode;

  const BuyerNegotiationDetail(
      {this.customerId,
      this.auctionId,
      this.auctionCode,
      this.auctionName,
      this.deliveryAddress,
      this.deliveryState,
      this.paymentTerm,
      this.partialDelivery,
      this.status,
      this.isStarted,
      this.isclosed,
      this.startDate,
      this.endDate,
      this.preferredDate,
      this.auctionUrl,
      this.auctionStatus,
      this.auctionCodeUrl,
      this.auctionColorCode});

  @override
  List<Object?> get props => [
        customerId,
        auctionId,
        auctionCode,
        auctionName,
        deliveryAddress,
        deliveryState,
        paymentTerm,
        partialDelivery,
        status,
        isStarted,
        isclosed,
        startDate,
        endDate,
        preferredDate,
        auctionUrl,
        auctionStatus,
        auctionCodeUrl,
        auctionColorCode
      ];
}
