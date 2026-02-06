import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class GetAllListUsecase implements UseCase<AllListDetail, GetAllListParams> {
  final DashboardRepository dasboardRepository;

  GetAllListUsecase({required this.dasboardRepository});
  @override
  Future<Either<Failure, AllListDetail>> call(GetAllListParams params) =>
      dasboardRepository.getAllList(params);
}

class GetAllListParams extends Equatable {
  final String token;
  final String groupID;
  const GetAllListParams({required this.token, required this.groupID});
  @override
  List<Object?> get props => [token, groupID];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "GroupID": groupID,
      };
}
