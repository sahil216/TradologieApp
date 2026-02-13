import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class GetCountryCodeListUsecase
    implements UseCase<List<CountryCodeList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  GetCountryCodeListUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<CountryCodeList>>> call(NoParams params) =>
      authenticationRepository.getCountryCodeList(params);
}
