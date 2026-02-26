import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';

class CommonAppbar extends StatelessWidget {
  final String title;
  final double expandedHeight;

  /// ⭐ NEW CONTROLS
  final bool showBackButton;
  final bool showNotification;

  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;

  final Widget? addAction; // 👈 pill button
  final Brightness statusBarBrightness;
  final Brightness statusBarIconBrightness;

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
        statusBarColor: Colors.transparent,
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
              Container(color: Colors.white),

              /// 💎 LIQUID GLASS (NO BASELINE CUT)
              Positioned(
                top: topSafe,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blur,
                      sigmaY: blur,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-0.6 + (1 - ease) * .3, -1),
                          end: const Alignment(1, 1),
                          colors: [
                            Colors.white.withOpacity(.96),
                            Colors.white.withOpacity(.82),
                          ],
                        ),
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
                        child: _glassActionWrapper(
                          GestureDetector(
                            onTap:
                                onBackTap ?? () => Navigator.maybePop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                    /// 🍏 TITLE
                    Positioned(
                      left: showBackButton ? 52 : 20,
                      right: (showNotification || addAction != null) ? 150 : 20,
                      bottom: baseline,
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
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
                        child: _glassActionWrapper(
                          GestureDetector(
                            onTap: () {
                              sl<NavigationService>()
                                  .pushNamed(Routes.notificationScreen);
                            },
                            child: const Icon(Icons.notifications_none),
                          ),
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: child,
        ),
      ),
    );
  }
}
