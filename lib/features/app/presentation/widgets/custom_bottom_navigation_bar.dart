import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/presentation/view_model/tab_view_model.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<TabViewModel> tabs;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 40,
          sigmaY: 40,
        ), // 🍎 stronger iOS blur
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white.withOpacity(.65),
            border: Border.all(
              color: Colors.white.withOpacity(.7),
              width: .8,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 40,
                offset: const Offset(0, 16),
                color: Colors.black.withOpacity(.12),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / tabs.length;

              return Stack(
                children: [
                  /// 🍎 iOS 17 SOFT ACTIVE GLOW CAPSULE
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment(
                      -1 + (2 / (tabs.length - 1)) * currentIndex,
                      0,
                    ),
                    child: Container(
                      width: tabWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(.55),
                            Colors.white.withOpacity(.25),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  /// 🍎 ICONS (APPLE MOTION)
                  Row(
                    children: tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isActive = index == currentIndex;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => onTap(index),
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            tween: Tween(begin: 0, end: isActive ? 1 : 0),
                            builder: (context, rawValue, child) {
                              // 🔒 Clamp once (Apple-style safe guard)
                              final value = rawValue.clamp(0.0, 1.0);

                              final iconColor = Color.lerp(
                                AppColors.grayText.withOpacity(.7),
                                CupertinoColors.black,
                                value,
                              );

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 1 +
                                        (value * .12), // still feels springy
                                    child: Icon(
                                      (item.icon as Icon).icon,
                                      size: 24,
                                      color: iconColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Opacity(
                                    opacity:
                                        0.6 + (value * 0.4), // ✅ guaranteed 0–1
                                    child: Text(
                                      item.name,
                                      style: TextStyleConstants.medium(
                                        context,
                                        fontSize: 11,
                                        color: iconColor!,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
