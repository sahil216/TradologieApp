import 'package:flutter/material.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';

ThemeData appTheme(BuildContext context, ) {
  return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily:  AppStrings.fontFamily,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              fontFamily:  AppStrings.fontFamily,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20)),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
            fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: AppColors.primary));
}
