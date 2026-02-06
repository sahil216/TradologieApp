import 'package:flutter/material.dart';

class CommonSingleChildScrollView extends StatelessWidget {
  final Widget child;
  final ScrollPhysics physics;
  final bool keyboardDismiss;
  final Axis scrollDirection;
  final ScrollController? controller;
  final EdgeInsets? padding;

  const CommonSingleChildScrollView({
    super.key,
    required this.child,
    this.physics = const BouncingScrollPhysics(),
    this.keyboardDismiss = true,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding,
      controller: controller,
      scrollDirection: scrollDirection,
      keyboardDismissBehavior: keyboardDismiss
          ? ScrollViewKeyboardDismissBehavior.onDrag
          : ScrollViewKeyboardDismissBehavior.manual,
      child: child,
    );
  }
}
