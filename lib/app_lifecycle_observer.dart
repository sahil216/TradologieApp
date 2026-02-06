import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  static AppLifecycleState? currentState;

  void startObserving() {
    WidgetsBinding.instance.addObserver(this);
    currentState = WidgetsBinding.instance.lifecycleState;
  }

  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    currentState = state;
  }

  static bool get isInForeground =>
      currentState == AppLifecycleState.resumed ||
      currentState == AppLifecycleState.inactive;
}
