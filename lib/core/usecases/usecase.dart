import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import '../error/failures.dart';
import '../utils/app_strings.dart';
import '../utils/secure_storage_service.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class DefaultParams extends Equatable {
  final String token;
  final String? vendorId;
  final String? customerId;
  const DefaultParams({required this.token, this.vendorId, this.customerId});
  @override
  List<Object?> get props => [token, vendorId, customerId];

  static Future<DefaultParams> fromStorage(
    SecureStorageService storage,
  ) async {
    final token = await storage.read(AppStrings.apiVerificationCode) ?? '';
    final vendorId = await storage.read(AppStrings.vendorId) ?? '';
    final customerId = await storage.read(AppStrings.customerId) ?? '';

    return DefaultParams(
      token: token,
      vendorId: vendorId,
      customerId: customerId,
    );
  }

  Map<String, dynamic> toJson() => {
        "Token": token,
        if (Constants.isBuyer == true && customerId != null && customerId != "")
          "CustomerID": customerId,
        if (vendorId != null && vendorId != "" && Constants.isBuyer == false)
          "VendorID": vendorId,
      };
}
