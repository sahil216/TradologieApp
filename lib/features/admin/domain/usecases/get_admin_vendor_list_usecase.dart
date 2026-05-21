import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_vendor.dart';
import '../repositories/admin_repository.dart';

enum AdminVendorSearchType { name, mobile, email }

class GetAdminVendorListUsecase
    implements UseCase<List<AdminVendor>, GetAdminVendorListParams> {
  final AdminRepository adminRepository;

  GetAdminVendorListUsecase({required this.adminRepository});

  @override
  Future<Either<Failure, List<AdminVendor>>> call(
          GetAdminVendorListParams params) =>
      adminRepository.getVendorList(params);
}

class GetAdminVendorListParams extends Equatable {
  final String query;
  final AdminVendorSearchType searchType;

  const GetAdminVendorListParams({
    required this.query,
    required this.searchType,
  });

  @override
  List<Object?> get props => [query, searchType];

  Map<String, dynamic> toJson(String token) {
    final trimmed = query.trim();
    return {
      'Token': token,
      'Name': searchType == AdminVendorSearchType.name ? trimmed : '',
      'Mobile': searchType == AdminVendorSearchType.mobile ? trimmed : '',
      'Email': searchType == AdminVendorSearchType.email ? trimmed : '',
    };
  }
}
