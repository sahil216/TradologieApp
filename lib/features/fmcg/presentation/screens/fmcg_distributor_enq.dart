import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';

class T {
  // Color
  static const bg = Color(0xFFFFFFFF);
  static const blue = Color(0xFF007AFF);
  static const ink = Color(0xFF0A0A0A);
  static const muted = Color(0xFF8A8A8E);
  static const faint = Color(0xFFE8E8ED);

  // Status — all desaturated so they never shout
  static const statusNew = Color(0xFF34C759);
  static const statusReview = Color(0xFFFF9500);
  static const statusContacted = Color(0xFF8E8E93);

  // Type scale
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    color: ink,
    letterSpacing: -1.0,
    height: 1.05,
    fontFamily: AppStrings.fontFamily,
  );
  static const TextStyle title = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: ink,
    letterSpacing: -0.2,
    fontFamily: AppStrings.fontFamily,
  );
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: muted,
    letterSpacing: -0.1,
    fontFamily: AppStrings.fontFamily,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: muted,
    letterSpacing: 0.1,
    fontFamily: AppStrings.fontFamily,
  );
  static const TextStyle mono = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: blue,
    letterSpacing: -0.2,
    fontFamily: AppStrings.fontFamily,
  );
}
