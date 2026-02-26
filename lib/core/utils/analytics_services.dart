import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static bool _ready = false;

  static Future<void> init() async {
    _ready = true;
  }

  static Future<void> logScreen(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
    print("Analytics event fired: $name");
  }
}
