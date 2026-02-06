import 'package:flutter/material.dart';

import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.radius = 8,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.elevation = 0,
    this.textStyle,
    this.icon,
    this.isIconOnly = false,
    this.isLoading = false,
    this.margin,
    this.borderSide,
  });

  final String? text;
  final VoidCallback onPressed;

  final double? height;
  final double? width;
  final BorderSide? borderSide;

  final double radius;
  final BorderRadiusGeometry? borderRadius;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final TextStyle? textStyle;

  final Widget? icon;
  final bool isIconOnly;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final resolvedRadius = borderRadius ?? BorderRadius.circular(radius);

    final resolvedHeight = height ?? 48;

    Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        side: borderSide,
        elevation: elevation,
        padding: isIconOnly
            ? EdgeInsets.zero // ⭐ KEY FIX
            : padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: isIconOnly
            ? Size(resolvedHeight, resolvedHeight) // ⭐ FORCE SQUARE
            : Size(0, resolvedHeight),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: resolvedRadius),
      ),
      child: isLoading
          ? SizedBox(
              height: 22,
              width: 22,
              child: const CommonLoader(),
            )
          : isIconOnly
              ? icon
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: 8),
                    ],
                    Text(
                      text ?? '',
                      style: textStyle ??
                          TextStyleConstants.medium(
                            context,
                            fontSize: 15,
                            color: AppColors.white,
                          ),
                    ),
                  ],
                ),
    );

    if (margin != null) {
      button = Padding(padding: margin!, child: button);
    }

    // ⭐ THIS IS THE KEY
    return width == null
        ? IntrinsicWidth(child: button) // 🔥 GUARANTEED wrap content
        : SizedBox(
            width: width == double.infinity ? double.infinity : width!,
            height: resolvedHeight,
            child: button,
          );
  }
}
