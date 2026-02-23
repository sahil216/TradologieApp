import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/get_vendor_stock_list.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class GetVendorStockListingUsecase
    implements UseCase<List<GetVendorStockList>, GetVendorStockListingParams> {
  final DashboardRepository dasboardRepository;

  GetVendorStockListingUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, List<GetVendorStockList>>> call(
          GetVendorStockListingParams params) =>
      dasboardRepository.getReadyStockListing(params);
}

class GetVendorStockListingParams extends Equatable {
  final String token;
  final String requirementID;
  final String query;

  const GetVendorStockListingParams({
    required this.token,
    required this.requirementID,
    required this.query,
  });

  @override
  List<Object?> get props => [token, requirementID, query];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "RequirementID": requirementID,
        "Query": query,
      };
}
