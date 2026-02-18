import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_update_auction_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AddUpdateAuctionUsecase
    implements UseCase<AddUpdateAuctionData, AddUpdateAuctionParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AddUpdateAuctionUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, AddUpdateAuctionData>> call(
          AddUpdateAuctionParams params) =>
      addNegotiationRepository.addUpdateAuction(params);
}

class AddUpdateAuctionParams extends Equatable {
  final String token;
  final String customerID;
  final String auctionID;
  final String auctionCode;
  final String auctionName;
  final String deliveryAddress;
  final String inspectionAgency;
  final String paymentTerm;
  final String bankerName;
  final String currency;
  final String partialDelivery;
  final String auctionStartDate;
  final String userTimeZone;
  final String totalQuantity;
  final String minQuantity;
  final String deliveryLastDate;
  final String agencyName;
  final String agencyAddress;
  final String agencyPhone;
  final String agencyEmail;
  final String remarks;

  const AddUpdateAuctionParams({
    required this.token,
    required this.customerID,
    required this.auctionID,
    required this.auctionCode,
    required this.auctionName,
    required this.deliveryAddress,
    required this.inspectionAgency,
    required this.paymentTerm,
    required this.bankerName,
    required this.currency,
    required this.partialDelivery,
    required this.auctionStartDate,
    required this.userTimeZone,
    required this.totalQuantity,
    required this.minQuantity,
    required this.deliveryLastDate,
    required this.agencyName,
    required this.agencyAddress,
    required this.agencyPhone,
    required this.agencyEmail,
    required this.remarks,
  });

  @override
  List<Object?> get props => [
        token,
        customerID,
        auctionID,
        auctionCode,
        auctionName,
        deliveryAddress,
        inspectionAgency,
        paymentTerm,
        bankerName,
        currency,
        partialDelivery,
        auctionStartDate,
        userTimeZone,
        totalQuantity,
        minQuantity,
        deliveryLastDate,
        agencyName,
        agencyAddress,
        agencyPhone,
        agencyEmail,
        remarks
      ];

  Map<String, dynamic> toJson() {
    return {
      "Token": token,
      "CustomerID": customerID,
      "AuctionID": auctionID,
      "AuctionCode": auctionCode,
      "AuctionName": auctionName,
      "DeliveryAddress": deliveryAddress,
      "InspectionAgency": inspectionAgency,
      "PaymentTerm": paymentTerm,
      "BankerName": bankerName,
      "Currency": currency,
      "PartialDelivery": partialDelivery,
      "AuctionStartDate": auctionStartDate,
      "UserTimeZone": userTimeZone,
      "TotalQuantity": totalQuantity,
      "MinQuantity": minQuantity,
      "DeliveryLastDate": deliveryLastDate,
      "AgencyName": agencyName,
      "AgencyAddress": agencyAddress,
      "AgencyPhone": agencyPhone,
      "AgencyEmail": agencyEmail,
      "Remarks": remarks
    };
  }
}
