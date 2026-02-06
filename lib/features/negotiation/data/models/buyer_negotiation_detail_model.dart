import '../../domain/entities/buyer_negotitation_detail.dart';

class BuyerNegotiationDetailModel extends BuyerNegotiationDetail {
  const BuyerNegotiationDetailModel({
    super.customerId,
    super.auctionId,
    super.auctionCode,
    super.auctionName,
    super.deliveryAddress,
    super.deliveryState,
    super.paymentTerm,
    super.partialDelivery,
    super.status,
    super.isStarted,
    super.isclosed,
    super.startDate,
    super.endDate,
    super.preferredDate,
    super.auctionUrl,
    super.auctionStatus,
    super.auctionCodeUrl,
    super.auctionColorCode,
  });

  factory BuyerNegotiationDetailModel.fromJson(Map<String, dynamic> json) =>
      BuyerNegotiationDetailModel(
        customerId: json["CustomerID"],
        auctionId: json["AuctionID"],
        auctionCode: json["AuctionCode"],
        auctionName: json["AuctionName"],
        deliveryAddress: json["DeliveryAddress"],
        deliveryState: json["DeliveryState"],
        paymentTerm: json["PaymentTerm"],
        partialDelivery: json["PartialDelivery"],
        status: json["Status"],
        isStarted: json["IsStarted"],
        isclosed: json["Isclosed"],
        startDate: json["StartDate"],
        endDate: json["EndDate"],
        preferredDate: json["PreferredDate"],
        auctionUrl: json["AuctionUrl"],
        auctionStatus: json["AuctionStatus"],
        auctionCodeUrl: json["AuctionCodeUrl"],
        auctionColorCode: json["AuctionColorCode"],
      );
}
