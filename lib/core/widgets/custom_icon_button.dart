import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget? icon;

  final bool flipX;
  final bool flipY;

  final double? width;
  final double? height;
  final double? radius;
  final double? iconWidth;
  final double? iconHeight;
  final double splashRadius;

  final Color? iconColor;
  final Color? backgroundColor;

  final Widget? widget;

  final BoxShape shape;
  final BoxBorder? border;

  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  final void Function() onPressed;

  final List<BoxShadow>? boxShadow;

  const CustomIconButton({
    super.key,
    this.icon,
    //
    this.flipX = false,
    this.flipY = false,
    //
    this.width,
    this.height,
    this.radius,
    this.iconWidth,
    this.iconHeight,
    this.splashRadius = 18,
    //
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    //
    this.widget,
    this.shape = BoxShape.rectangle,
    this.border,
    //
    this.padding,
    this.borderRadius,
    //
    required this.onPressed,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        shape: shape,
        borderRadius: borderRadius ??
            (radius != null ? BorderRadius.circular(radius!) : null),
        boxShadow: boxShadow,
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          minHeight: height ?? 0,
          maxWidth: width ?? double.infinity,
          minWidth: width ?? 0,
        ),
        splashRadius: splashRadius,
        icon: widget ?? Transform.flip(flipX: flipX, flipY: flipY, child: icon),
      ),
    );
  }
}
