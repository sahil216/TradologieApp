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

  /// Background
  final Gradient? backgroundGradient;
  final Color scaffoldBackgroundColor;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.useSafeArea = true,
    this.resizeToAvoidBottomInset = true,
    this.maxContentWidth,
    this.backgroundGradient,
    this.scaffoldBackgroundColor = Colors.white,
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
          decoration: BoxDecoration(
            gradient: backgroundGradient ?? _defaultGradient,
          ),
          child: _buildContent(context, r),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Responsive r) {
    final content = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxContentWidth ??
              (r.isTablet ? r.screenWidth * 0.9 : double.infinity),
        ),
        child: body,
      ),
    );

    return useSafeArea ? SafeArea(child: content) : content;
  }

  static const _defaultGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF7FBFF),
      Color(0xFFEAF4FF),
      Color(0xFFDCEEFF),
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );
}
