import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';

import '../entities/notification_detail.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationDetail>>> getNotification(
      NoParams params);
}
