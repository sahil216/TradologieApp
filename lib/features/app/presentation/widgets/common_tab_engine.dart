import 'package:flutter/material.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/features/app/presentation/view_model/tab_view_model.dart';

class CupertinoTabEngine extends StatefulWidget {
  final List<TabViewModel> tabs;
  final int currentIndex;

  const CupertinoTabEngine({
    super.key,
    required this.tabs,
    required this.currentIndex,
  });

  @override
  State<CupertinoTabEngine> createState() => CupertinoTabEngineState();
}

class CupertinoTabEngineState extends State<CupertinoTabEngine> {
  late List<GlobalKey<NavigatorState>> _navigatorKeys;

  @override
  void initState() {
    super.initState();
    _navigatorKeys =
        List.generate(widget.tabs.length, (_) => GlobalKey<NavigatorState>());
  }

  /// 🔥 VERY IMPORTANT — handle tab count change (4 → 5 items)
  @override
  void didUpdateWidget(covariant CupertinoTabEngine oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs.length != widget.tabs.length) {
      _navigatorKeys = List.generate(
        widget.tabs.length,
        (i) => i < _navigatorKeys.length
            ? _navigatorKeys[i] // keep old navigator state
            : GlobalKey<NavigatorState>(),
      );
    }
  }

  /// 🔥 expose pop for MainScreen
  Future<bool> popCurrentTab(int index) async {
    if (index >= _navigatorKeys.length) return false;

    final navigator = _navigatorKeys[index].currentState;

    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.tabs.length, (index) {
        final isActive = widget.currentIndex == index;

        return IgnorePointer(
          ignoring: !isActive,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: isActive ? 1 : 0,
            child: Navigator(
              key: _navigatorKeys[index],
              onGenerateRoute: (_) => FadeCupertinoPageRoute(
                builder: (_) => widget.tabs[index].page,
              ),
            ),
          ),
        );
      }),
    );
  }
}
