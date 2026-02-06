import 'package:flutter/material.dart';

import 'package:tradologie_app/core/utils/app_strings.dart';

import 'text_style_constants.dart';

class CommonText extends StatelessWidget {
  const CommonText(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.style,
  });

  final String text;

  /// Custom overrides
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;

  /// Fully custom style (highest priority)
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultStyle = TextStyleConstants.regular(context,
        fontSize: (fontSize ?? 14),
        height: height,
        color: color,
        fontWeight: fontWeight,
        decoration: decoration,
        fontFamily: AppStrings.fontFamily);

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: style ?? defaultStyle,
    );
  }
}
