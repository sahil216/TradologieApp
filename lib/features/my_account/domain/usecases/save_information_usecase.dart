import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/my_account_repository.dart';

class SaveInformationUsecase implements UseCase<bool, SaveInformationParams> {
  final MyAccountRepository myAccountRepository;

  SaveInformationUsecase({required this.myAccountRepository});
  @override
  Future<Either<Failure, bool>> call(SaveInformationParams params) =>
      myAccountRepository.saveInformation(params);
}

class SaveInformationParams {
  final String token,
      vendorID,
      vendorName,
      vendorDescription,
      priority,
      isActive,
      annualturnover,
      yearOfEstablishment,
      certifications,
      areaOfOperation;

  SaveInformationParams({
    required this.token,
    required this.vendorID,
    required this.vendorName,
    required this.vendorDescription,
    required this.priority,
    required this.isActive,
    required this.annualturnover,
    required this.yearOfEstablishment,
    required this.certifications,
    required this.areaOfOperation,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "VendorID": vendorID,
        "VendorName": vendorName,
        "VendorDescription": vendorDescription,
        "Priority": priority,
        "IsActive": isActive,
        "annualturnover": annualturnover,
        "YearOfEstablishment": yearOfEstablishment,
        "Certifications": certifications,
        "AreaOfOperation": areaOfOperation,
      };
}
