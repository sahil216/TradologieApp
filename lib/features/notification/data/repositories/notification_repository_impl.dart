import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/notification/data/models/notification_detail_model.dart';
import 'package:tradologie_app/features/notification/domain/entities/notification_detail.dart';

import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;

  NotificationRepositoryImpl({
    required this.notificationRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<NotificationDetail>>> getNotification(
      NoParams params) async {
    try {
      final response =
          await notificationRemoteDataSource.getNotification(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => NotificationDetailModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
