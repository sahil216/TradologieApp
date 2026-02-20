import 'package:flutter/material.dart';

class TabViewModel {
  final Widget icon;
  final String name;
  final Widget page;
  final double height;
  final int? badgeCount;
  final bool? isActive;

  const TabViewModel({
    required this.icon,
    required this.name,
    required this.page,
    required this.height,
    this.badgeCount,
    this.isActive,
  });
}
