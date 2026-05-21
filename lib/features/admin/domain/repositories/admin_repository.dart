import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_vendor.dart';
import '../usecases/get_admin_vendor_list_usecase.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<AdminVendor>>> getVendorList(
    GetAdminVendorListParams params,
  );

  Future<Either<Failure, List<AdminVendor>>> getAgroSellerChatList(
    NoParams params,
  );
}
