import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  /// Layout
  final bool useSafeArea;
  final bool resizeToAvoidBottomInset;
  final double? maxContentWidth;
  final bool extendBodyBehindAppBar;

  /// Background
  final Gradient? backgroundGradient;
  final Color scaffoldBackgroundColor;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.maxContentWidth,
    this.backgroundGradient,
    this.scaffoldBackgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: true,
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: _defaultGradient),
          child: _buildContent(context, r),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Responsive r) {
    final content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth ??
              (r.isTablet ? r.screenWidth * 0.9 : double.infinity),
        ),
        child: SizedBox.expand(
          child: body,
        ),
      ),
    );

    return useSafeArea ? SafeArea(child: content) : content;
  }

  static const _defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0199F6), // 600 — deep blue top
      Color(0xFF2CB3FF),
      Color(0xFFDEF0FF),
      Color(0xFFDEF0FF), // 50  — near-white pale blue bottom
    ],
    stops: [0.0, 0.10, 0.38, 1.0],
  );
}
