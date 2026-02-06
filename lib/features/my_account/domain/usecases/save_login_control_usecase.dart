import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/my_account/domain/repositories/my_account_repository.dart';

class SaveLoginControlUsecase implements UseCase<bool, SaveLoginControlParams> {
  final MyAccountRepository myAccountRepository;

  SaveLoginControlUsecase({required this.myAccountRepository});
  @override
  Future<Either<Failure, bool>> call(SaveLoginControlParams params) =>
      myAccountRepository.saveLoginControl(params);
}

class SaveLoginControlParams {
  final String token;
  final String vendorID;
  final String vendorName;
  final String mobileNo;
  final String userID;
  final String password;

  SaveLoginControlParams({
    required this.token,
    required this.vendorID,
    required this.vendorName,
    required this.mobileNo,
    required this.userID,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "VendorID": vendorID,
        "VendorName": vendorName,
        "MobileNo": mobileNo,
        "UserID": userID,
        "Password": password,
      };
}
