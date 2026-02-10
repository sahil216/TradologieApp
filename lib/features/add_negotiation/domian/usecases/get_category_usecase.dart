import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

class GetCategoryUsecase implements UseCase<List<CommodityList>, NoParams> {
  final AddNegotiationRepository addNegotiationRepository;

  GetCategoryUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, List<CommodityList>>> call(NoParams params) =>
      addNegotiationRepository.getCategoryList(params);
}
