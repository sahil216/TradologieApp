import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/notification/domain/entities/notification_detail.dart';

import '../../domain/usecases/notification_usecase.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationUsecase notificationUsecase;

  NotificationCubit({
    required this.notificationUsecase,
  }) : super(NotificationInitial());

  Future<void> getNotification(NoParams params) async {
    emit(NotificationIsLoading());
    Either<Failure, List<NotificationDetail>> response =
        await notificationUsecase(params);
    emit(response.fold(
      (failure) => NotificationError(failure: failure),
      (res) => NotificationSuccess(data: res),
    ));
  }
}
