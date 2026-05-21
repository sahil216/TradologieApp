import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';

/// Persists unread push count, updates launcher badge, and notifies in-app UI.
class NotificationBadgeService extends ChangeNotifier {
  NotificationBadgeService(this._prefs);

  final SharedPreferences _prefs;

  int get count => _prefs.getInt(AppStrings.pushNotificationBadgeCount) ?? 0;

  Future<int> increment() async {
    final next = count + 1;
    await _prefs.setInt(AppStrings.pushNotificationBadgeCount, next);
    await _applyLauncherBadge(next);
    notifyListeners();
    return next;
  }

  Future<void> clear() async {
    await _prefs.setInt(AppStrings.pushNotificationBadgeCount, 0);
    await _applyLauncherBadge(0);
    notifyListeners();
  }

  Future<void> syncFromStorage() async {
    await _applyLauncherBadge(count);
    notifyListeners();
  }

  /// Rebuild in-app badges after background pushes (count already in prefs).
  void refresh() => notifyListeners();

  static Future<void> incrementInBackground() async {
    final prefs = await SharedPreferences.getInstance();
    await NotificationBadgeService(prefs).increment();
  }

  static Future<void> _applyLauncherBadge(int count) async {
    if (!await AppBadgePlus.isSupported()) return;
    await AppBadgePlus.updateBadge(count);
  }
}
