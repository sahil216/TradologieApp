import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  static AppLifecycleState? currentState;

  VoidCallback? _onResumed;

  void startObserving({VoidCallback? onResumed}) {
    _onResumed = onResumed;
    WidgetsBinding.instance.addObserver(this);
    currentState = WidgetsBinding.instance.lifecycleState;
  }

  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    currentState = state;
    if (state == AppLifecycleState.resumed) {
      _onResumed?.call();
    }
  }

  static bool get isInForeground =>
      currentState == AppLifecycleState.resumed ||
      currentState == AppLifecycleState.inactive;
}
