import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/domain/entities/get_information_detail.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/company_details_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/get_information_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_login_control_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_information_usecase.dart';

import '../../../../core/error/failures.dart';
part 'my_account_state.dart';

class MyAccountCubit extends Cubit<MyAccountState> {
  final GetInformationUsecase getInformationUsecase;
  final CompanyDetailsUsecase companyDetailsUsecase;
  final SaveInformationUsecase saveInformationUsecase;
  final SaveLoginControlUsecase saveLoginControlUsecase;

  MyAccountCubit(
      {required this.getInformationUsecase,
      required this.saveInformationUsecase,
      required this.saveLoginControlUsecase,
      required this.companyDetailsUsecase})
      : super(MyAccountInitial());

  Future<void> getInformation(NoParams params) async {
    emit(GetInformationIsLoading());
    Either<Failure, GetInformationDetail> response =
        await getInformationUsecase(params);
    emit(response.fold(
      (failure) => GetInformationError(failure: failure),
      (res) => GetInformationSuccess(data: res),
    ));
  }

  Future<void> companyDetails(NoParams params) async {
    emit(CompanyDetailsIsLoading());
    Either<Failure, CompanyDetails> response =
        await companyDetailsUsecase(params);
    emit(response.fold(
      (failure) => CompanyDetailsError(failure: failure),
      (res) => CompanyDetailsSuccess(data: res),
    ));
  }

  Future<void> saveInformation(SaveInformationParams params) async {
    emit(SaveInformationIsLoading());
    Either<Failure, bool> response = await saveInformationUsecase(params);
    emit(response.fold(
      (failure) => SaveInformationError(failure: failure),
      (res) => SaveInformationSuccess(data: res),
    ));
  }
}
