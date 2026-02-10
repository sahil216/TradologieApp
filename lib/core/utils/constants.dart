import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/routes/navigation_service.dart';
import '../../core/utils/extensions.dart';
import '../../injection_container.dart';
import '../error/failures.dart';
import '../error/network_failure.dart';
import '../error/user_failure.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_text/text_style_constants.dart';
import 'app_colors.dart';
import 'assets_manager.dart';

class Constants {
  static bool isLogin = false;
  static bool isBuyer = false;

  static String name = "";

  static PreferredSizeWidget appBar(
    BuildContext context, {
    Key? key,
    String title = "",
    double height = 70,
    double leadingWidth = 60,
    PreferredSizeWidget? bottom,
    double titleSpacing = 0,
    double elevation = 0,
    bool centerTitle = false,
    Color? iconBackColor,
    Color? backgroundColor,
    Color? systemNavigationBarColor,
    Widget? leading,
    Widget? titleWidget,
    Widget? flexibleSpace,
    List<Widget>? actions,
    List<BoxShadow>? boxShadow,
    BorderRadiusGeometry? borderRadius,
    Brightness statusBarBrightness = Brightness.light,
    Brightness statusBarIconBrightness = Brightness.dark,
  }) {
    return PreferredSize(
      preferredSize: Size(context.width, height),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: boxShadow ??
              [
                // BoxShadow(
                //   blurRadius: 4,
                //   spreadRadius: 0,
                //   offset: const Offset(0, 1),
                //   color: AppColors.black.withValues(alpha: 0.1),
                // ),
              ],
          // borderRadius: borderRadius ??
          // BorderRadius.vertical(
          //   bottom: Radius.circular(10),
          // ),
          color: backgroundColor ?? AppColors.white,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ??
              BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
          child: AppBar(
            key: key,
            leadingWidth: leadingWidth,
            titleSpacing: titleSpacing,
            toolbarHeight: height,
            bottom: bottom,
            elevation: elevation,
            centerTitle: centerTitle,
            backgroundColor: backgroundColor ?? AppColors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.transparent,
              systemNavigationBarColor:
                  systemNavigationBarColor ?? AppColors.white,
              statusBarIconBrightness: statusBarIconBrightness,
              statusBarBrightness: statusBarBrightness,
            ),
            flexibleSpace: flexibleSpace,
            leading: leading ??
                Builder(
                  builder: (context) {
                    final scaffold = Scaffold.maybeOf(context);

                    if (scaffold?.hasDrawer ?? false) {
                      return GestureDetector(
                          onTap: () => scaffold!.openDrawer(),
                          child: SizedBox(
                            width: 12,
                            height: 12,
                            child: Image.asset(
                              ImgAssets.menu,
                            ),
                          ));
                    }

                    // Else if can pop → show back button
                    if (Navigator.canPop(context)) {
                      return defaultBackButton(context);
                    }

                    return const SizedBox.shrink();
                  },
                ),
            title: titleWidget ??
                CommonText(
                  title,
                  style: TextStyleConstants.bold(
                    context,
                    height: 2,
                    fontSize: 22,
                    color: AppColors.black,
                  ),
                ),
            actions: actions,
          ),
        ),
      ),
    );
  }

  static bool isAndroid14OrBelow = false;

  Future<void> checkAndroidVersion() async {
    if (!Platform.isAndroid) {
      isAndroid14OrBelow = true;
      return;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    isAndroid14OrBelow = androidInfo.version.sdkInt <= 34; // Android 14
  }

  static Widget defaultBackButton(BuildContext context,
      {Color? iconColor, double? iconWidth}) {
    return CustomIconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      widget: Icon(Icons.arrow_back_ios_new),
      iconColor: iconColor ?? AppColors.primary,
      iconWidth: iconWidth ?? 28,
    );
  }

  static String dateFormat(DateTime date) {
    return DateFormat('dd-MMM-yyyy HH:mm').format(date);
  }

  static Future<void> launch(
    String url, {
    bool openExternal = true,
  }) async {
    try {
      final uri = Uri.parse(url);

      final success = await launchUrl(
        uri,
        mode: openExternal
            ? LaunchMode.externalApplication
            : LaunchMode.inAppWebView,
      );

      if (!success) {
        debugPrint('❌ Failed to launch: $url');
      }
    } catch (e) {
      debugPrint('❌ URL launch exception: $e');
    }
  }

  static void showWarningDialog({
    required BuildContext context,
    required String msg,
    required void Function() onClickYes,
    void Function()? onClickNo,
    Function(bool, dynamic)? onPopInvoked,
    String? textYes,
    bool? canPop,
    bool barrierDismissible = true,
  }) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.black,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return PopScope(
          canPop: canPop ?? true,
          onPopInvokedWithResult: onPopInvoked,
          child: Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: context.bottom + 8,
                        left: 24,
                        right: 24,
                        top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 20, bottom: 10, left: 20, right: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CommonText(
                                  msg,
                                  textAlign: TextAlign.center,
                                  style: TextStyleConstants.semiBold(
                                    context,
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                CommonButton(
                                  onPressed: onClickYes,
                                  padding: EdgeInsets.zero,
                                  backgroundColor: AppColors.white,
                                  text: textYes ?? ("yes"),
                                  elevation: 1,
                                  textStyle: TextStyleConstants.semiBold(
                                    context,
                                    height: 1.22,
                                    fontSize: 14,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 12,
                    child: GestureDetector(
                      onTap: onClickNo ??
                          () {
                            Navigator.pop(context);
                          },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: AppColors.border,
                          ),
                        ),
                        child: Icon(
                          Icons.cancel,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  static void showNormalToast({
    required String msg,
    Color? color,
  }) {
    var context = sl<NavigationService>().navigationKey.currentContext;
    if (context != null) {
      FToast fToast = FToast();
      fToast.init(context);
      fToast.showToast(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: color ?? AppColors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 4,
            ),
            child: CommonText(
              msg,
              textAlign: TextAlign.center,
              style: TextStyleConstants.medium(
                context,
                fontSize: 12,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      );
    }
  }

  static void showConnectInternetSnackbar({
    required BuildContext context,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      toastDuration: const Duration(seconds: 5),
      child: SafeArea(
        left: false,
        right: false,
        top: false,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! > 5) {
              fToast.removeCustomToast();
            }
          },
          child: Container(
            width: context.width,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.only(
                top: 10, bottom: context.bottom + 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.black,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              spacing: 6,
              children: [
                Icon(
                  Icons.wifi_rounded,
                  size: 25,
                  color: AppColors.white,
                ),
                Expanded(
                  child: CommonText(
                    ("Internet connection not available"),
                    textAlign: TextAlign.start,
                    style: TextStyleConstants.medium(
                      context,
                      color: AppColors.white,
                    ),
                  ),
                ),
                CustomIconButton(
                  onPressed: () {
                    fToast.removeCustomToast();
                  },
                  iconHeight: 25,
                  iconWidth: 25,
                  height: 25,
                  width: 25,
                  widget: Container(
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 1,
                        color: AppColors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      gravity: ToastGravity.SNACKBAR,
    );
  }

  static void showErrorInternetSnackbar({
    required BuildContext context,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      toastDuration: const Duration(seconds: 5),
      child: SafeArea(
        left: false,
        right: false,
        top: false,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! > 5) {
              fToast.removeCustomToast();
            }
          },
          child: Container(
            width: context.width,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.only(
                top: 10, bottom: context.bottom + 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.black,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              spacing: 6,
              children: [
                Icon(
                  Icons.wifi_off_outlined,
                  size: 25,
                  color: AppColors.white,
                ),
                Expanded(
                  child: CommonText(
                    ("no_internet_connection"),
                    textAlign: TextAlign.start,
                    style: TextStyleConstants.medium(
                      context,
                      color: AppColors.white,
                    ),
                  ),
                ),
                CustomIconButton(
                  onPressed: () {
                    fToast.removeCustomToast();
                  },
                  iconHeight: 25,
                  iconWidth: 25,
                  height: 25,
                  width: 25,
                  widget: Container(
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 1,
                        color: AppColors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      gravity: ToastGravity.SNACKBAR,
    );
  }

  static void showErrorToast({
    required BuildContext context,
    String? msg,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      toastDuration: const Duration(seconds: 6),
      child: SafeArea(
        left: false,
        right: false,
        top: false,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! > 5) {
              fToast.removeCustomToast();
            }
          },
          child: Container(
            width: context.width,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.only(
                top: 10, bottom: context.bottom + 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              spacing: 6,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.white,
                  size: 21,
                ),
                Expanded(
                  child: CommonText(
                    msg ?? ("something_went_wrong"),
                    textAlign: TextAlign.start,
                    style: TextStyleConstants.medium(
                      context,
                      color: AppColors.white,
                    ),
                  ),
                ),
                CustomIconButton(
                  onPressed: () {
                    fToast.removeCustomToast();
                  },
                  iconHeight: 25,
                  iconWidth: 25,
                  height: 25,
                  width: 25,
                  widget: Container(
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 1,
                        color: AppColors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      gravity: ToastGravity.SNACKBAR,
    );
  }

  static void showSuccessToast({
    required BuildContext context,
    String? msg,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      child: SafeArea(
        left: false,
        right: false,
        top: false,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta != null && details.primaryDelta! > 5) {
              fToast.removeCustomToast();
            }
          },
          child: Container(
            width: context.width,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.only(top: 2, bottom: 2, left: 10, right: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              spacing: 6,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.white,
                  size: 25,
                ),
                Expanded(
                  child: CommonText(
                    msg ?? "success",
                    textAlign: TextAlign.start,
                    style: TextStyleConstants.medium(
                      context,
                      color: AppColors.white,
                    ),
                  ),
                ),
                CustomIconButton(
                  onPressed: () {
                    fToast.removeCustomToast();
                  },
                  iconHeight: 25,
                  iconWidth: 25,
                  height: 25,
                  width: 25,
                  widget: Container(
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 1,
                        color: AppColors.white,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      gravity: ToastGravity.SNACKBAR,
    );
  }

  static void showFailureToast(Failure failure) {
    var context = sl<NavigationService>().navigationKey.currentContext;
    if (context != null) {
      if (failure is NetworkFailure) {
        Constants.showErrorInternetSnackbar(
          context: context,
        );
      } else if (failure is UserFailure) {
        Constants.showErrorToast(
          context: context,
          msg: failure.msg,
        );
      } else {
        Constants.showErrorToast(
          context: context,
        );
      }
    }
  }
}
