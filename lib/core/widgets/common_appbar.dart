import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';

class CommonAppbar extends StatelessWidget {
  final String title;
  final double expandedHeight;

  /// ⭐ NEW CONTROLS
  final bool showBackButton;
  final bool showNotification;
  final bool? showLogo;
  final bool showWebview;

  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;

  final Widget? addAction; // 👈 pill button
  final Brightness statusBarBrightness;
  final Brightness statusBarIconBrightness;
  final bool? showSuffixIcon;
  final Widget? suffixIcon;

  const CommonAppbar({
    super.key,
    required this.title,
    this.expandedHeight = 80,
    this.showBackButton = false,
    this.showNotification = false,
    this.onBackTap,
    this.onNotificationTap,
    this.statusBarBrightness = Brightness.light,
    this.statusBarIconBrightness = Brightness.dark,
    this.addAction,
    this.showLogo = false,
    this.showSuffixIcon,
    this.suffixIcon,
    this.showWebview = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      expandedHeight: expandedHeight,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double topSafe = MediaQuery.of(context).padding.top;
          final double min = kToolbarHeight;
          final double percent =
              ((constraints.maxHeight - min) / (expandedHeight - min))
                  .clamp(0.0, 1.0);

          final ease = Curves.easeOutQuart.transform(percent);
          final scale = 0.88 + (ease * .12);
          final blur = 14 + (1 - ease) * 10;

          /// ⭐ MASTER BASELINE (EVERYTHING LOCKED HERE)
          const double baseline = 8;

          return Stack(
            fit: StackFit.expand,
            children: [
              /// 🤍 PURE WHITE NOTCH BACKGROUND
              showWebview == true
                  ? Container(
                      color: Colors.white,
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF042B4D), Color(0xFF064474)],
                        ),
                      ),
                    ),

              /// 💎 LIQUID GLASS (NO BASELINE CUT)
              Positioned(
                top: topSafe,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: Container(
                    decoration: showWebview == true
                        ? BoxDecoration(color: Colors.white)
                        : BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF042B4D), Color(0xFF064474)],
                            ),
                          ),
                  ),
                ),
              ),

              /// ⭐ SINGLE SAFEAREA STACK (NO DUPLICATES)
              SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    /// 🔙 BACK BUTTON
                    if (showBackButton)
                      Positioned(
                        left: 12,
                        bottom: baseline,
                        child: GestureDetector(
                          onTap: onBackTap ?? () => Navigator.maybePop(context),
                          child: _glassActionWrapper(
                            const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    /// 🍏 TITLE
                    Align(
                      alignment: AlignmentGeometry.bottomCenter,
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.bottomLeft,
                        child: showLogo == true
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Image.asset(
                                  ImgAssets.companyLogo,
                                  height: 40,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    /// ➕ ADD ACTION (ONLY ONE PLACE)
                    if (addAction != null)
                      Positioned(
                        right: showNotification ? 70 : 12,
                        bottom: baseline,
                        child: _glassActionWrapper(addAction!),
                      ),

                    /// 🔔 NOTIFICATION
                    if (showNotification)
                      Positioned(
                        right: 12,
                        bottom: baseline,
                        child: GestureDetector(
                          onTap: () {
                            sl<NavigationService>()
                                .pushNamed(Routes.notificationScreen);
                          },
                          child: _glassActionWrapper(
                            const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    if (showSuffixIcon == true)
                      Positioned(
                        right: 12,
                        bottom: baseline,
                        child: _glassActionWrapper(
                          suffixIcon ?? SizedBox(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _glassActionWrapper(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: child,
      ),
    );
  }
}
