import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_product_category_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgSellerProductCategoryListUsecase
    implements UseCase<List<FmcgSellerProductCategoryList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerProductCategoryListUsecase(
      {required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgSellerProductCategoryList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgSellerProductCategoryList(params);
}
