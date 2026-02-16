import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../view_model/tab_view_model.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<TabViewModel> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🚑 HARD GUARD — prevents ALL crashes
    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(32),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabCount = tabs.length;
              final maxWidth = constraints.maxWidth;

              // 🚑 SAFETY CLAMP
              final double itemWidth =
                  (tabCount > 0 && maxWidth > 0) ? maxWidth / tabCount : 0.0;

              final safeIndex = math.min(currentIndex, tabCount - 1).toDouble();

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  /// 🍎 SAFE SPRING INDICATOR
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: safeIndex),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      // 💉 HARD CLAMP — prevents NaN
                      final clampedValue = value.isFinite ? value : safeIndex;

                      final left = clampedValue * itemWidth;

                      return Positioned(
                        left: left,
                        top: 6,
                        bottom: 6,
                        width: itemWidth,
                        child: Align(
                          alignment: Alignment.center,
                          child: FractionallySizedBox(
                            widthFactor: .9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .06),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  /// 🍎 TAB ITEMS
                  Row(
                    children: List.generate(tabCount, (index) {
                      final tab = tabs[index];
                      final selected = index == currentIndex;

                      return Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onTap(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: selected ? 1.05 : 1,
                                  curve: Curves.easeOut,
                                  child: IconTheme(
                                    data: IconThemeData(
                                      size: 24,
                                      color: selected
                                          ? Colors.black
                                          : Colors.black45,
                                    ),
                                    child: tab.icon,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 180),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: selected
                                        ? Colors.black
                                        : Colors.black45,
                                  ),
                                  child: Text(tab.name),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
