import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_vendor.dart';
import '../repositories/admin_repository.dart';

class GetAgroSellerChatListUsecase implements UseCase<List<AdminVendor>, NoParams> {
  final AdminRepository adminRepository;

  GetAgroSellerChatListUsecase({required this.adminRepository});

  @override
  Future<Either<Failure, List<AdminVendor>>> call(NoParams params) =>
      adminRepository.getAgroSellerChatList(params);
}
