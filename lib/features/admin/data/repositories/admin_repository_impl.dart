import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/user_failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/admin_vendor.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/usecases/get_admin_vendor_list_usecase.dart';
import '../datasources/admin_remote_data_source.dart';
import '../models/admin_vendor_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource adminRemoteDataSource;

  AdminRepositoryImpl({required this.adminRemoteDataSource});

  @override
  Future<Either<Failure, List<AdminVendor>>> getVendorList(
    GetAdminVendorListParams params,
  ) async {
    try {
      final response = await adminRemoteDataSource.getVendorList(params);
      if (response != null && response.success) {
        final list = response.data as List;
        return Right(
          list
              .map((e) => AdminVendorModel.fromVendorListJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList(),
        );
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<AdminVendor>>> getAgroSellerChatList(
    NoParams params,
  ) async {
    try {
      final response =
          await adminRemoteDataSource.getAgroSellerChatList(params);
      if (response != null && response.success) {
        final list = response.data as List;
        return Right(
          list
              .map((e) => AdminVendorModel.fromChatListJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList(),
        );
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
