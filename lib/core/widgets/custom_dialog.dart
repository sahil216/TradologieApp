import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';

import '../../../core/utils/extensions.dart';
import '../utils/app_colors.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Animation<double> a1;
  final Animation<double> a2;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  const CustomDialog({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.a1,
    required this.a2,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1).animate(a1),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1).animate(a1),
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: alignment ?? Alignment.bottomCenter,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  margin: margin ??
                      EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: context.top + 16,
                        bottom: context.bottom + 16,
                      ),
                  padding: EdgeInsets.only(
                    top: 24,
                    bottom: 24,
                    left: 18,
                    right: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: CommonSingleChildScrollView(
                      child: child,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
