import 'package:flutter/material.dart';

import 'custom_text/text_style_constants.dart';

import '../utils/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final String? title;
  //
  final double fontSize;
  //
  final Widget? titleWidget;
  //
  final bool value;
  //
  final Color? textColor;
  //
  final TextDirection? textDirection;
  //
  final EdgeInsetsGeometry? margin;
  //
  final void Function() onTap;

  const CustomCheckbox({
    super.key,
    this.title,
    //
    this.fontSize = 14,
    //
    this.titleWidget,
    //
    required this.value,
    //
    this.textColor,
    //
    this.textDirection,
    //
    this.margin,
    //
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        color: AppColors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: textDirection,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  width: 1,
                  color: value ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 16,
                color: AppColors.white,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: titleWidget ??
                  Text(
                    title ?? "",
                    style: TextStyleConstants.regular(
                      context,
                      height: 1.3,
                      fontSize: fontSize,
                      color: !value ? AppColors.defaultText : textColor,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
