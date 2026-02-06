import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/dashboard_result.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../respositories/dashboard_repository.dart';

class GetDashboardUsecase
    implements UseCase<List<DashboardResult>, GetDashboardParams> {
  final DashboardRepository dasboardRepository;

  GetDashboardUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, List<DashboardResult>>> call(
          GetDashboardParams params) =>
      dasboardRepository.getDashboardData(params);
}

class GetDashboardParams extends Equatable {
  final String token;

  const GetDashboardParams({required this.token});

  @override
  List<Object?> get props => [token];

  Map<String, dynamic> toJson() => {
        "Token": token,
      };
}
