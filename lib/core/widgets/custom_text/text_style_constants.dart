import 'package:flutter/widgets.dart';

import 'package:tradologie_app/core/utils/app_strings.dart';

import '../../utils/app_colors.dart';

class TextStyleConstants {
  static TextStyle extraBold(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w800,
      );

  static TextStyle bold(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w700,
      );

  static TextStyle semiBold(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w600,
      );

  static TextStyle medium(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w500,
      );

  static TextStyle regular(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w400,
      );

  static TextStyle light(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w300,
      );

  static TextStyle extraLight(
    BuildContext context, {
    double? height,
    double fontSize = 16,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    FontWeight? fontWeight,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily ?? AppStrings.fontFamily,
        color: color ?? AppColors.defaultText,
        decorationColor: decorationColor,
        decoration: decoration ?? TextDecoration.none,
        shadows: shadows,
        fontWeight: fontWeight ?? FontWeight.w200,
      );
}
