import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  final Size _size;

  Responsive(this.context) : _size = MediaQuery.of(context).size;

  /// Screen size
  double get screenWidth => _size.width;
  double get screenHeight => _size.height;

  /// Device type
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  /// Full size helpers
  double fullWidth([double factor = 1]) => screenWidth * factor;
  double fullHeight([double factor = 1]) => screenHeight * factor;

  /// Responsive value selector
  double value({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Padding helpers
  EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: fullWidth(horizontal),
      vertical: fullHeight(vertical),
    );
  }

  /// Width constraint for forms / dialogs
  double get formMaxWidth {
    if (isDesktop) return 720;
    if (isTablet) return 600;
    return screenWidth;
  }

  /// Height safe for scroll layouts
  double get bodyHeight => screenHeight - MediaQuery.of(context).padding.top;

  /// Aspect-aware height (useful for banners)
  double bannerHeight({
    double mobileRatio = 0.25,
    double tabletRatio = 0.3,
  }) {
    return isTablet ? fullHeight(tabletRatio) : fullHeight(mobileRatio);
  }
}
