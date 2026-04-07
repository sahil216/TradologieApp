import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/extensions.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/custom_text/text_style_constants.dart';
import 'app_colors.dart';
import 'assets_manager.dart';

class Constants {
  static bool isLogin = false;
  static bool isBuyer = false;
  static bool isFmcg = false;
  static String token = "";
  static String deviceID = "";
  static String analyticsUrl = "";

  bool? hideSensitiveData;

  static String timeZone = "";

  static String name = "";

  bool isTodayInRange(DateTime fromDate, DateTime toDate) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final end = DateTime(toDate.year, toDate.month, toDate.day);

    return !today.isBefore(start) && !today.isAfter(end);
  }

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
      child: ClipRRect(
        borderRadius: borderRadius ??
            const BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
        child: Stack(
          children: [
            /// 💎 ULTRA LIQUID GLASS BACKGROUND
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(-0.5, -1),
                      end: const Alignment(1, 1),
                      colors: [
                        Colors.white.withValues(alpha: .96),
                        Colors.white.withValues(alpha: .82),
                      ],
                    ),
                    boxShadow: boxShadow ??
                        [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black.withValues(alpha: .04),
                          ),
                        ],
                  ),
                ),
              ),
            ),

            /// 🔥 REAL APPBAR LAYER
            AppBar(
              key: key,
              leadingWidth: leadingWidth,
              titleSpacing: titleSpacing,
              toolbarHeight: height,
              bottom: bottom,
              elevation: 0,
              centerTitle: centerTitle,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor:
                    systemNavigationBarColor ?? Colors.white,
                statusBarIconBrightness: statusBarIconBrightness,
                statusBarBrightness: statusBarBrightness,
              ),
              flexibleSpace: flexibleSpace,

              /// 🍏 LEADING (UNCHANGED LOGIC)
              leading: leading ??
                  Builder(
                    builder: (context) {
                      final scaffold = Scaffold.maybeOf(context);

                      if (scaffold?.hasDrawer ?? false) {
                        return GestureDetector(
                          onTap: () => scaffold!.openDrawer(),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: .8),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Image.asset(ImgAssets.menu),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (Navigator.canPop(context)) {
                        return defaultBackButton(context);
                      }

                      return const SizedBox.shrink();
                    },
                  ),

              /// 💎 ULTRA TITLE STYLE (V101 MATCH)
              title: titleWidget ??
                  CommonText(
                    title,
                    style: TextStyleConstants.bold(
                      context,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),

              actions: actions?.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .8),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: e,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
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

  String maskPhone(String phone) {
    if (phone.length <= 4) return "****";
    return "${phone.substring(0, 2)}********";
  }

  String maskEmail(String email) {
    final parts = email.split("@");
    if (parts.length != 2) return "****@****.com";

    String name = parts[0];
    String domain = parts[1];

    String maskedName = name.length <= 2 ? "**" : "${name.substring(0, 2)}****";
    String maskedDomain = domain.length <= 2 ? "**" : "****";

    return "$maskedName@$maskedDomain";
  }

  String maskName(String name) {
    if (name.isEmpty) return "";

    List<String> parts = name.split(" ");

    return parts.map((part) {
      if (part.length <= 1) return "x";
      return part[0] + part[1] + "x" * (part.length - 2);
    }).join(" ");
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

  static final ValueNotifier<bool> hasUnread = ValueNotifier(false);

  static void update(List<ChatList> chats) {
    final unreadExists = chats.any((e) => e.isReadMessage == false);

    hasUnread.value = unreadExists;
  }

  static void clear() {
    hasUnread.value = false;
  }

  // static void showNormalToast({
  //   required String msg,
  //   Color? color,
  // }) {
  //   final context = sl<NavigationService>().navigationKey.currentContext;
  //   if (context == null) return;

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(msg, textAlign: TextAlign.center),
  //       backgroundColor: color ?? AppColors.black.withValues(alpha: 0.8),
  //       behavior: SnackBarBehavior.floating,
  //       duration: const Duration(seconds: 2),
  //       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //     ),
  //   );
  // }

  // static void showConnectInternetSnackbar({
  //   required BuildContext context,
  // }) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 5),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: AppColors.black,
  //       margin: EdgeInsets.only(
  //         bottom: context.bottom + 10,
  //         left: 10,
  //         right: 10,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       content: Row(
  //         children: [
  //           Icon(Icons.wifi_rounded, color: AppColors.white, size: 25),
  //           const SizedBox(width: 6),
  //           Expanded(
  //             child: CommonText(
  //               "Internet connection not available",
  //               style: TextStyleConstants.medium(
  //                 context,
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       action: SnackBarAction(
  //         label: "✕",
  //         textColor: AppColors.white,
  //         onPressed: () {
  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         },
  //       ),
  //     ),
  //   );
  // }

  // static void showErrorInternetSnackbar({
  //   required BuildContext context,
  // }) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 5),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: AppColors.black,
  //       margin: EdgeInsets.only(
  //         bottom: context.bottom + 10,
  //         left: 10,
  //         right: 10,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       content: Row(
  //         children: [
  //           Icon(Icons.wifi_off_outlined, color: AppColors.white, size: 25),
  //           const SizedBox(width: 6),
  //           Expanded(
  //             child: CommonText(
  //               "no_internet_connection",
  //               style: TextStyleConstants.medium(
  //                 context,
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       action: SnackBarAction(
  //         label: "✕",
  //         textColor: AppColors.white,
  //         onPressed: () {
  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         },
  //       ),
  //     ),
  //   );
  // }

  // static void showErrorToast({
  //   required BuildContext context,
  //   String? msg,
  // }) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 4),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: AppColors.primary,
  //       margin: EdgeInsets.only(
  //         bottom: context.bottom + 10,
  //         left: 10,
  //         right: 10,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       content: Row(
  //         children: [
  //           Icon(Icons.error_outline, color: AppColors.white, size: 21),
  //           const SizedBox(width: 6),
  //           Expanded(
  //             child: CommonText(
  //               msg ?? "something_went_wrong",
  //               style: TextStyleConstants.medium(
  //                 context,
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       action: SnackBarAction(
  //         label: "✕",
  //         textColor: AppColors.white,
  //         onPressed: () {
  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         },
  //       ),
  //     ),
  //   );
  // }

  // static void showSuccessToast({
  //   required BuildContext context,
  //   String? msg,
  // }) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       duration: const Duration(seconds: 3),
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: AppColors.primary,
  //       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(6),
  //       ),
  //       content: Row(
  //         children: [
  //           Icon(Icons.check_circle_outline_rounded,
  //               color: AppColors.white, size: 25),
  //           const SizedBox(width: 6),
  //           Expanded(
  //             child: CommonText(
  //               msg ?? "success",
  //               style: TextStyleConstants.medium(
  //                 context,
  //                 color: AppColors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       action: SnackBarAction(
  //         label: "✕",
  //         textColor: AppColors.white,
  //         onPressed: () {
  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         },
  //       ),
  //     ),
  //   );
  // }

  // static void showFailureToast(Failure failure) {
  //   final context = sl<NavigationService>().navigationKey.currentContext;
  //   if (context == null) return;

  //   if (failure is NetworkFailure) {
  //     showErrorInternetSnackbar(context: context);
  //   } else if (failure is UserFailure) {
  //     showErrorToast(context: context, msg: failure.msg);
  //   } else {
  //     showErrorToast(context: context);
  //   }
  // }
}
