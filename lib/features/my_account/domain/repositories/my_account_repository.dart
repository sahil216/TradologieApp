import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/domain/entities/get_information_detail.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_login_control_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_information_usecase.dart';

import '../../../../core/error/failures.dart';

abstract class MyAccountRepository {
  Future<Either<Failure, bool>> saveInformation(SaveInformationParams params);
  Future<Either<Failure, GetInformationDetail>> getInformation(NoParams params);
  Future<Either<Failure, bool>> saveLoginControl(SaveLoginControlParams params);
  Future<Either<Failure, CompanyDetails>> companyDetails(NoParams params);
}
