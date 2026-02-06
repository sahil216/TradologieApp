import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final bool? isSafearea;
  final Widget? drawer;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
    this.isSafearea = true,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      drawer: drawer,
      extendBody: true,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF7FBFF),
              Color(0xFFEAF4FF),
              Color(0xFFDCEEFF),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: isSafearea == true
            ? SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          r.isTablet ? r.screenWidth * 0.9 : double.infinity,
                    ),
                    child: body,
                  ),
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: r.isTablet ? 720 : double.infinity,
                  ),
                  child: body,
                ),
              ),
      ),
    );
  }
}
