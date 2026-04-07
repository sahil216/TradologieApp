import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/contact_us/more_options_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_list_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_my_account_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_seller_dashboard_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

// ── Nav bar visibility controller ─────────────────────────────────────────────
// Any child screen can show/hide the bottom bar by calling:
//
//   NavBarVisibility.of(context).show();
//   NavBarVisibility.of(context).hide();
//
// No prop drilling needed — works from anywhere in the widget tree.

class NavBarVisibilityController extends ChangeNotifier {
  bool _visible = true;
  bool get visible => _visible;

  void show() {
    if (!_visible) {
      _visible = true;
      notifyListeners();
    }
  }

  void hide() {
    if (_visible) {
      _visible = false;
      notifyListeners();
    }
  }
}

class NavBarVisibility extends InheritedNotifier<NavBarVisibilityController> {
  const NavBarVisibility({
    super.key,
    required NavBarVisibilityController controller,
    required super.child,
  }) : super(notifier: controller);

  static NavBarVisibilityController of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<NavBarVisibility>();
    assert(inherited != null, 'No NavBarVisibility found in context');
    return inherited!.notifier!;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class CommonFMCGFloatingNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final int unreadCount;

  const CommonFMCGFloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (Constants.isBuyer == true) ...[
            _item(0, Icons.dashboard_outlined, "BrandHub"),
            _item(1, Icons.chat_outlined, "Connect"),
            _item(2, Icons.local_grocery_store_outlined, "FMCG"),
            _item(3, Icons.menu_rounded, "More"),
          ] else ...[
            _item(0, Icons.dashboard_outlined, "Dashboard"),
            _item(1, Icons.chat_outlined, "Connect"),
            _item(2, Icons.account_circle_outlined, "Account"),
            _item(3, Icons.menu_rounded, "More"),
            _item(4, Icons.analytics, "Analytics"),
          ]
        ],
      ),
    );
  }

  Widget _item(int i, IconData icon, String label) {
    final bool selected = i == index;
    final bool isChat = i == 1;

    const activeColor = Color(0xFF0A9FED);
    const inactiveColor = Colors.black87;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: selected ? 20 : 0,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? activeColor : inactiveColor,
                ),
                if (isChat && unreadCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Per-tab navigator wrapper ─────────────────────────────────────────────────
// Each tab gets its own Navigator so pushing a new screen stays inside the
// body area and the bottom bar remains visible at all times.

class _TabNavigator extends StatelessWidget {
  final Widget rootScreen;
  final String navigatorKey;

  const _TabNavigator({
    required this.rootScreen,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: ValueKey(navigatorKey),
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => rootScreen,
      ),
    );
  }
}

// ── Main Screen ───────────────────────────────────────────────────────────────

class FMCGMainScreen extends StatefulWidget {
  const FMCGMainScreen({super.key});

  @override
  State<FMCGMainScreen> createState() => _FMCGMainScreenState();
}

class _FMCGMainScreenState extends State<FMCGMainScreen> {
  int currentIndex = 0;
  int unreadCount = 0;
  SecureStorageService secureStorage = SecureStorageService();
  final NavBarVisibilityController _navBarController =
      NavBarVisibilityController();

  // One navigator key per tab so each tab keeps its own back-stack
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    5,
    (_) => GlobalKey<NavigatorState>(),
  );

  Future<void> nameUpdate() async {
    Constants.name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
            ? await secureStorage.read(AppStrings.customerName) ?? ""
            : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  Future<void> analyticsUpdate() async {
    Constants.analyticsUrl =
        await secureStorage.read(AppStrings.analyticsUrl) ?? "";
  }

  @override
  void initState() {
    super.initState();
    nameUpdate();
    analyticsUpdate();
  }

  // ── Root screens (one per tab) ─────────────────────────────────────────────
  List<Widget> get _sellerRoots => [
        FmcgSellerDashboardScreen(),
        ChatListScreen(),
        FmcgMyAccountScreen(),
        MoreOptionsScreen(),
        Constants.isAndroid14OrBelow && Platform.isAndroid
            ? InAppWebViewScreen(
                params: WebviewParams(
                    url: Constants.analyticsUrl, canPop: false, isAppBar: true))
            : WebViewScreen(
                params: WebviewParams(
                url: Constants.analyticsUrl,
                canPop: false,
                isAppBar: true,
              )),
      ];

  List<Widget> get _buyerRoots => [
        FmcgBuyerDashboardScreen(),
        ChatListScreen(),
        Constants.isAndroid14OrBelow && Platform.isAndroid
            ? InAppWebViewScreen(
                params: WebviewParams(
                    url: "https://www.tradologie.com/fmcg-view",
                    canPop: false,
                    isAppBar: true))
            : WebViewScreen(
                params: WebviewParams(
                url: "https://www.tradologie.com/fmcg-view",
                canPop: false,
                isAppBar: true,
              )),
        MoreOptionsScreen(),
      ];

  void onTabChanged(int index) {
    // If tapping the already-active tab, pop to its root
    if (index == currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
      return;
    }
    setState(() => currentIndex = index);
  }

  // Handle Android back button — pop within the nested navigator first
  Future<bool> _onWillPop() async {
    final canPop = _navigatorKeys[currentIndex].currentState?.canPop() ?? false;
    if (canPop) {
      _navigatorKeys[currentIndex].currentState?.pop();
      return false; // don't pop the main screen
    }
    return true; // let the OS handle it (exit app)
  }

  @override
  void dispose() {
    _navBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roots = Constants.isBuyer == true ? _buyerRoots : _sellerRoots;

    return NavBarVisibility(
      controller: _navBarController,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: AdaptiveScaffold(
          body: Stack(
            children: List.generate(roots.length, (i) {
              return Offstage(
                offstage: currentIndex != i,
                child: Navigator(
                  key: _navigatorKeys[i],
                  onGenerateRoute: (_) => MaterialPageRoute(
                    builder: (_) => roots[i],
                  ),
                ),
              );
            }),
          ),
          bottomNavigationBar: ListenableBuilder(
            listenable: _navBarController,
            builder: (context, _) {
              return AnimatedSize(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: Constants.hasUnread,
                    builder: (context, hasUnread, _) {
                      return CommonFMCGFloatingNavBar(
                        index: currentIndex,
                        onTap: onTabChanged,
                        unreadCount: hasUnread ? 1 : 0, // just flag-based
                      );
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }
}
