import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/auction_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class GetAuctionUnitUsecase implements UseCase<List<AuctionUnitList>, String> {
  final DashboardRepository dasboardRepository;

  GetAuctionUnitUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, List<AuctionUnitList>>> call(String params) =>
      dasboardRepository.getAuctionUnit(params);
}
