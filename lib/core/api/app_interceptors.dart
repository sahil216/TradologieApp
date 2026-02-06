// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

import '../../config/routes/app_router.dart';
import '../../config/routes/navigation_service.dart';
import '../utils/app_strings.dart';
import '../utils/constants.dart';

class AppIntercepters extends Interceptor {
  final SharedPreferences sharedPreferences;
  final NavigationService navigationService;
  final PackageInfo packageInfo;

  AppIntercepters({
    required this.sharedPreferences,
    required this.navigationService,
    required this.packageInfo,
  });

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');

    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.accept] = AppStrings.applicationJson;

    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    _onResponse(response);
    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    if (err.response != null) {
      _onResponse(err.response!);
    }
    super.onError(err, handler);
  }

  Future<void> _onResponse(Response response) async {
    if (response.statusCode == 401) {
      SecureStorageService secureStorage = SecureStorageService();
      secureStorage.delete(AppStrings.apiVerificationCode);
      secureStorage.delete(AppStrings.appSession);
      Constants.isLogin = false;
      navigationService.pushNamedAndRemoveUntil(Routes.onboardingRoute);
      final ctx = navigationService.navigationKey.currentContext;
      Constants.showErrorToast(context: ctx!, msg: (AppStrings.sessionExpired));

      // if (ctx != null) {
      //   Constants.showWarningDialog(
      //     context: ctx,
      //     msg: AppStrings.sessionExpired,
      //     onClickYes: () {
      //       Navigator.pop(ctx);
      //     },
      //   );
      //   Future.delayed(
      //     const Duration(milliseconds: 200),
      //     () {
      //       FocusManager.instance.primaryFocus?.unfocus();
      //     },
      //   );
      // }
    }

    //   final lastVersionNum = int.tryParse(xAppVersion?.replaceAll(".", "") ?? "");
    //   final currentVersionNum =
    //       int.tryParse(packageInfo.version.replaceAll(".", ""));
    //   final isContainsVersion = sharedPreferences.containsKey(xAppVersion ?? "");

    //   if (lastVersionNum != null &&
    //       currentVersionNum != null &&
    //       currentVersionNum < lastVersionNum &&
    //       (xUpdateRequired || !isContainsVersion)) {
    //     if (!isContainsVersion) {
    //       sharedPreferences.setString(xAppVersion!, "");
    //     }
    //     final ctx = navigationService.navigationKey.currentContext;
    //     if (ctx != null) {
    //       Constants.showWarningDialog(
    //         context: ctx,
    //         msg: Platform.isAndroid
    //             ? ("update_message_google")
    //             : ("update_message_app_store"),
    //         canPop: xUpdateRequired,
    //         barrierDismissible: false,
    //         onClickYes: () {
    //           if (Platform.isAndroid) {
    //             AppStrings.linkAppOnGooglePlay.launchUrl;
    //           } else {
    //             AppStrings.linkAppOnAppStore.launchUrl;
    //           }
    //         },
    //         onClickNo: () {
    //           if (xUpdateRequired) {
    //             SystemNavigator.pop();
    //           } else {
    //             Navigator.pop(ctx);
    //           }
    //         },
    //         textYes: ("upgrade"),
    //       );
    //     }
    //   }
  }
}
