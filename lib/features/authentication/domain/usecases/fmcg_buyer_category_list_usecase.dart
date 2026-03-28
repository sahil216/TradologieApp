import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_category_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgBuyerCategoryListUsecase
    implements UseCase<List<FmcgBuyerCategoryList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgBuyerCategoryListUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgBuyerCategoryList>>> call(NoParams params) =>
      authenticationRepository.fmcgBuyerCategoryList(params);
}
