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
          decoration: BoxDecoration(color: Color(0xFFF4F4F4)),
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

    return useSafeArea ? content : content;
  }

  // static const _defaultGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [
  //     // Colors.black,
  //     Color.fromARGB(255, 215, 239, 248),
  //     Color.fromARGB(255, 229, 246, 252),
  //     Color.fromARGB(255, 255, 255, 255),
  //     // Colors.white,
  //   ],
  //   stops: [0.1, 0.5, 1.0],
  // );
}
