import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgCountryCodeListUsecase
    implements UseCase<List<FmcgCountryCodeList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgCountryCodeListUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgCountryCodeList>>> call(NoParams params) =>
      authenticationRepository.fmcgGetCountryCodeList(params);
}
