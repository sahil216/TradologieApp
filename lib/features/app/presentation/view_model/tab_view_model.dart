import 'package:flutter/material.dart';

class TabViewModel {
  final double height;
  final String icon;
  final String name;
  final Widget page;

  TabViewModel({
    required this.height,
    required this.icon,
    required this.name,
    required this.page,
  });
}
