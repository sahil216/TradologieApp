import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class GetCommodityListUsecase
    implements UseCase<List<CommodityList>, NoParams> {
  final DashboardRepository dasboardRepository;

  GetCommodityListUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, List<CommodityList>>> call(NoParams params) =>
      dasboardRepository.getCommodityList(params);
}
