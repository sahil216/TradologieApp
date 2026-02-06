import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

import '../../../../core/usecases/usecase.dart';

class DeleteAccountUsecase implements UseCase<bool, DeleteAccountParams> {
  final AuthenticationRepository authenticationRepository;

  DeleteAccountUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, bool>> call(DeleteAccountParams params) =>
      authenticationRepository.deleteAccount(params);
}

class DeleteAccountParams extends Equatable {
  final String token;
  final String customerID;
  final String message;

  const DeleteAccountParams(
      {required this.token, required this.customerID, required this.message});

  @override
  List<Object?> get props => [token, customerID, message];

  Map<String, dynamic> toJson() => {
        "Token": token,
        if (Constants.isBuyer == true) "CustomerID": customerID,
        if (Constants.isBuyer == false) "VendorID": customerID,
        "Message": message,
      };
}
