import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/my_account/data/datasources/my_account_remote_data_source.dart';
import 'package:tradologie_app/features/my_account/data/models/get_information_detail_model.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/domain/entities/get_information_detail.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_login_control_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_information_usecase.dart';

import '../../domain/repositories/my_account_repository.dart';
import '../models/company_details_model.dart';

class MyAccountRepositoryImpl implements MyAccountRepository {
  final MyAccountRemoteDataSource myAccountRemoteDataSource;

  MyAccountRepositoryImpl({
    required this.myAccountRemoteDataSource,
  });

  @override
  Future<Either<Failure, bool>> saveInformation(
      SaveInformationParams params) async {
    try {
      final response = await myAccountRemoteDataSource.saveInformation(params);
      if (response != null && response.success) {
        return Right(response.success);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CompanyDetails>> companyDetails(
      NoParams params) async {
    try {
      final response = await myAccountRemoteDataSource.companyDetails(params);
      if (response != null && response.success) {
        return Right(CompanyDetailsModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, GetInformationDetail>> getInformation(
      NoParams params) async {
    try {
      final response = await myAccountRemoteDataSource.getInformation(params);
      if (response != null && response.success) {
        return Right(GetInformationDetailModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> saveLoginControl(
      SaveLoginControlParams params) async {
    try {
      final response = await myAccountRemoteDataSource.saveLoginControl(params);
      if (response != null && response.success) {
        return Right(response.success);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
