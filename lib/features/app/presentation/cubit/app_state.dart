part of 'app_cubit.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class ChangeLocaleState extends AppState {
  final Locale locale;

  const ChangeLocaleState({required this.locale});

  @override
  List<Object> get props => [locale];
}

class ChangeTab extends AppState {
  final int tab;

  const ChangeTab({required this.tab});

  @override
  List<Object> get props => [tab];
}

class NetworkConnectState extends AppState {
  const NetworkConnectState();
}

class NetworkDisconnectState extends AppState {
  const NetworkDisconnectState();
}

class CheckForceUpdateIsLoading extends AppState {}

class CheckForceUpdateSuccess extends AppState {
  final bool data;

  const CheckForceUpdateSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class CheckForceUpdateError extends AppState {
  final Failure failure;

  const CheckForceUpdateError({required this.failure});

  @override
  List<Object> get props => [failure];
}
