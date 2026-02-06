part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationIsLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationDetail> data;

  const NotificationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class NotificationError extends NotificationState {
  final Failure failure;

  const NotificationError({required this.failure});

  @override
  List<Object> get props => [failure];
}
