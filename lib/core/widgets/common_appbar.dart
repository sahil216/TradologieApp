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

  final bool showBackButton;
  final bool showNotification;
  final bool? showLogo;
  final bool showWebview;

  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;

  final Widget? addAction;
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
      elevation: 5,
      expandedHeight: expandedHeight,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final double topSafe = MediaQuery.of(context).padding.top;
          final double min = kToolbarHeight;
          final double percent =
              ((constraints.maxHeight - min) / (expandedHeight - min))
                  .clamp(0.0, 1.0);

          final ease = Curves.easeOutQuart.transform(percent);
          final scale = 0.88 + (ease * .12);

          const double baseline = 8;

          return Stack(
            fit: StackFit.expand,
            children: [
              /// 🎨 SINGLE UNIFIED GRADIENT — top-center dark blue → bottom-center white
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: showWebview == true
                    ? Container(color: Colors.white)
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF042B4D), // dark navy at top
                              Color(0xFFF4F4F4), // white at bottom
                            ],
                          ),
                        ),
                      ),
              ),

              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Stack(
                    children: [
                      if (showBackButton)
                        Positioned(
                          left: 12,
                          bottom: baseline,
                          child: GestureDetector(
                            onTap:
                                onBackTap ?? () => Navigator.maybePop(context),
                            child: _glassActionWrapper(
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                      /// 🍏 TITLE
                      Align(
                        alignment: Alignment.bottomCenter,
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      /// ➕ ADD ACTION
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
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                      if (showSuffixIcon == true)
                        Positioned(
                          right: 12,
                          bottom: baseline,
                          child: _glassActionWrapper(
                            suffixIcon ?? const SizedBox(),
                          ),
                        ),
                    ],
                  ),
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
