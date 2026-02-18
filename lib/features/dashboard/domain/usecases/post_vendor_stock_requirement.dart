import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class PostVendorStockRequirementUsecase
    implements UseCase<bool, PostVendorStockRequirementParams> {
  final DashboardRepository dasboardRepository;

  PostVendorStockRequirementUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, bool>> call(PostVendorStockRequirementParams params) =>
      dasboardRepository.postVendorStockRequirement(params);
}

class PostVendorStockRequirementParams extends Equatable {
  final String token;
  final String commodityID;
  final String subCommodityID;
  final String attribute1;
  final String attribute2;
  final String quantity;
  final String quantityUnit;
  final String otherSpecifications;
  final String userId;
  final String stockLocation;

  const PostVendorStockRequirementParams({
    required this.token,
    required this.commodityID,
    required this.subCommodityID,
    required this.attribute1,
    required this.attribute2,
    required this.quantity,
    required this.quantityUnit,
    required this.otherSpecifications,
    required this.userId,
    required this.stockLocation,
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
        stockLocation
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
        "StockLocation": stockLocation,
      };
}
