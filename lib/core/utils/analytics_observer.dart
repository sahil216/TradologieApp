import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';

class AnalyticsObserver extends NavigatorObserver {
  void _sendScreen(Route? route) {
    final name = route?.settings.name;
    if (name != null) {
      AnalyticsService.logScreen(name);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendScreen(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _sendScreen(newRoute);
  }
}
