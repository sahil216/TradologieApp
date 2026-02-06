import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_detail.dart';
import '../repositories/notification_repository.dart';

class NotificationUsecase
    implements UseCase<List<NotificationDetail>, NoParams> {
  final NotificationRepository notificationRepository;

  NotificationUsecase({required this.notificationRepository});
  @override
  Future<Either<Failure, List<NotificationDetail>>> call(NoParams params) =>
      notificationRepository.getNotification(params);
}
