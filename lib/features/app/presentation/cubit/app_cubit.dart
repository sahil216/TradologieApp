import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import '../../../../app_lifecycle_observer.dart';
import '../../domain/usecases/change_lang.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final ChangeLangUseCase changeLangUseCase;
  final InternetConnectionChecker networkInfo;
  final CheckForceUpdateUsecase checkForceUpdateUsecase;

  AppCubit(
      {required this.changeLangUseCase,
      required this.networkInfo,
      required this.checkForceUpdateUsecase})
      : super(AppInitial());

  int bottomNavIndex = 0;

  /// 🍎 REAL iOS tab change
  Future<void> changeTab(int tab) async {
    if (bottomNavIndex == tab) return;

    bottomNavIndex = tab;
    emit(ChangeTab(tab: tab));
  }

  /// 🍎 Sync tab index from animation (VERY IMPORTANT)

  Future<void> checkForceUpdate(ForceUpdateParams params) async {
    emit(CheckForceUpdateIsLoading());
    Either<Failure, bool> response = await checkForceUpdateUsecase(params);
    emit(response.fold(
      (failure) => CheckForceUpdateError(failure: failure),
      (res) => CheckForceUpdateSuccess(data: res),
    ));
  }

  late final StreamSubscription<InternetConnectionStatus> _subscription;
  InternetConnectionStatus _lastStatus = InternetConnectionStatus.connected;
  Future<void> networkConnection() async {
    _subscription = networkInfo.onStatusChange.listen((status) {
      if (AppLifecycleObserver.isInForeground && status != _lastStatus) {
        _lastStatus = status;

        if (status == InternetConnectionStatus.connected) {
          emit(const NetworkConnectState());
        } else if (status == InternetConnectionStatus.disconnected) {
          emit(const NetworkDisconnectState());
        }
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
