import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_distribution_coverage_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgBuyerDistributionCoverageListUsecase
    implements UseCase<List<FmcgBuyerDistributionCoverageList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgBuyerDistributionCoverageListUsecase(
      {required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgBuyerDistributionCoverageList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgBuyerDistributionCoverageList(params);
}
