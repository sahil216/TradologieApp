import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/domain/repositories/my_account_repository.dart';

class CompanyDetailsUsecase implements UseCase<CompanyDetails, NoParams> {
  final MyAccountRepository myAccountRepository;

  CompanyDetailsUsecase({required this.myAccountRepository});
  @override
  Future<Either<Failure, CompanyDetails>> call(NoParams params) =>
      myAccountRepository.companyDetails(params);
}
