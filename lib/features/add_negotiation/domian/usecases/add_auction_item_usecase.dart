import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AddAuctionItemUsecase implements UseCase<bool, AddAuctionItemParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AddAuctionItemUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(AddAuctionItemParams params) =>
      addNegotiationRepository.addAuctionItem(params);
}

class AddAuctionItemParams extends Equatable {
  final String token;
  final String customerID;
  final String auctionID;
  final String groupID;
  final String packingTypeID;
  final String packingSizeID;
  final String categoryID;
  final String customCategory;
  final String attributeValue1;
  final String attributeValue2;
  final String note;
  final String qty;
  final String unit;

  const AddAuctionItemParams({
    required this.token,
    required this.customerID,
    required this.auctionID,
    required this.groupID,
    required this.packingTypeID,
    required this.packingSizeID,
    required this.categoryID,
    required this.customCategory,
    required this.attributeValue1,
    required this.attributeValue2,
    required this.note,
    required this.qty,
    required this.unit,
  });

  @override
  List<Object?> get props => [
        token,
        customerID,
        auctionID,
        groupID,
        packingTypeID,
        packingSizeID,
        categoryID,
        customCategory,
        attributeValue1,
        attributeValue2,
        note,
        qty,
        unit
      ];

  Map<String, dynamic> toJson() {
    return {
      "Token": token,
      "CustomerID": customerID,
      "AuctionID": auctionID,
      "GroupID": groupID,
      "PackingTypeID": packingTypeID,
      "PackingSizeID": packingSizeID,
      "CategoryID": categoryID,
      "CustomCategory": customCategory,
      "AttributeValue1": attributeValue1,
      "AttributeValue2": attributeValue2,
      "Note": note,
      "Qty": qty,
      "Unit": unit
    };
  }
}
