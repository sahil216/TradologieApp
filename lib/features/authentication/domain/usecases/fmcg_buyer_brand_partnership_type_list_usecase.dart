import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_brand_partnership_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgBuyerBrandPartnershipTypeListUsecase
    implements UseCase<List<FmcgBuyerBrandPartnershipTypeList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgBuyerBrandPartnershipTypeListUsecase(
      {required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgBuyerBrandPartnershipTypeList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgBuyerBrandPartnershipList(params);
}
