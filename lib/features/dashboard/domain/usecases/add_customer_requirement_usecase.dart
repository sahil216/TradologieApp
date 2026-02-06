import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class AddCustomerRequirementUsecase
    implements UseCase<bool, AddCustomerRequirementParams> {
  final DashboardRepository dasboardRepository;

  AddCustomerRequirementUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, bool>> call(AddCustomerRequirementParams params) =>
      dasboardRepository.addCustomerRequirement(params);
}

class AddCustomerRequirementParams extends Equatable {
  final String token;
  final String commodityID;
  final String subCommodityID;
  final String attribute1;
  final String attribute2;
  final String quantity;
  final String quantityUnit;
  final String otherSpecifications;
  final String userId;

  const AddCustomerRequirementParams({
    required this.token,
    required this.commodityID,
    required this.subCommodityID,
    required this.attribute1,
    required this.attribute2,
    required this.quantity,
    required this.quantityUnit,
    required this.otherSpecifications,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        token,
        commodityID,
        subCommodityID,
        attribute1,
        attribute2,
        quantity,
        quantityUnit,
        otherSpecifications,
        userId,
      ];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "CommodityID": commodityID,
        "SubCommodityID": subCommodityID,
        "Attribute1": attribute1,
        "Attribute2": attribute2,
        "Quantity": quantity,
        "QuantityUnit": quantityUnit,
        "OtherSpecifications": otherSpecifications,
        "UserId": userId,
      };
}
// {
//   "Token": "gEQAgHjoIk1cPmY8JIAId4BmXKvbfxLtANnH",
//   "CommodityID": "1",
//   "SubCommodityID": "2",
//   "Attribute1": "1",
//   "Attribute2": "2",
//   "Quantity": "13",
//   "QuantityUnit": "1700",
//   "OtherSpecifications": "Details",
//   "UserId": "2"
// }
