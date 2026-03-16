import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_brands_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgBrandsListUsecase implements UseCase<List<FmcgBrandsList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgBrandsListUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgBrandsList>>> call(NoParams params) =>
      authenticationRepository.fmcgBrandsList(params);
}
