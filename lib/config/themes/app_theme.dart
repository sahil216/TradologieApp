import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';

ThemeData appTheme(
  BuildContext context,
) {
  return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: AppStrings.fontFamily,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.white,
          titleTextStyle: TextStyle(
              fontFamily: AppStrings.fontFamily,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              fontSize: 20)),
      textTheme: TextTheme(
        bodyMedium: TextStyleConstants.medium(context,
            fontSize: 20, color: AppColors.black, fontWeight: FontWeight.w500),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: AppColors.primary));
}
