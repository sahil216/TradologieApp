import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_partnership_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgSellerPartnershipTypeListUsecase
    implements UseCase<List<FmcgSellerPartnershipTypeList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerPartnershipTypeListUsecase(
      {required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgSellerPartnershipTypeList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgSellerPartnershipTypeList(params);
}
