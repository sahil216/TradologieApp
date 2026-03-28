import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_business_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgSellerBusinessTypeListUsecase
    implements UseCase<List<FmcgSellerBusinessTypeList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerBusinessTypeListUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgSellerBusinessTypeList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgSellerBusinessTypeList(params);
}
