import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class CommonToggleButton extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final double borderRadius;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;

  const CommonToggleButton({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.height = 36,
    this.borderRadius = 10,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.activeTextColor,
    this.inactiveTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.primary),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final bool isSelected = index == selectedIndex;

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor ?? AppColors.primary
                      : inactiveColor ?? AppColors.white,
                  borderRadius: BorderRadius.horizontal(
                    left: index == 0
                        ? Radius.circular(borderRadius)
                        : Radius.zero,
                    right: index == labels.length - 1
                        ? Radius.circular(borderRadius)
                        : Radius.zero,
                  ),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? activeTextColor ?? AppColors.white
                        : inactiveTextColor ?? AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
