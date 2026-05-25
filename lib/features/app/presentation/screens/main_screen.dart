import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_list_screen.dart';
import 'package:tradologie_app/features/admin/presentation/screens/admin_vendor_conversation_screen.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/blinking_online_dot.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/contact_us/demo_auction_screen.dart';
import 'package:tradologie_app/features/contact_us/more_options_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/buyer_negotiation_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/negotiation_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/notifications_service.dart';
import '../../../../injection_container.dart' show sl;
import '../cubit/app_cubit.dart';
import '../view_model/tab_view_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AppCubit _appCubit;

  String? token;

  List<TabViewModel> get supplierTabsList {
    if (token == null) {
      return []; // or loader
    }
    return [
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 0
            ? Icon(Icons.dashboard)
            : Icon(Icons.dashboard_outlined),
        name: 'Dashboard',
        height: 20,
        page: const DashboardScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 1
            ? Icon(Icons.article)
            : Icon(Icons.article_outlined),
        name: 'Negotiation',
        height: 20,
        page: const NegotiationScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 2
            ? Icon(Icons.description)
            : Icon(Icons.description_outlined),
        name: 'Demo',
        height: 20,
        page: const DemoAuctionScreen(isDemoAuction: true),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 3
            ? Icon(Icons.support_agent)
            : Icon(Icons.support_agent_outlined),
        name: 'Dedicated Support',
        height: 20,
        page: const AdminVendorConversationScreen(
          vendor: AdminConnectChatConfig.displayVendor,
          chatType1: AdminConnectChatConfig.type1,
          chatType2: AdminConnectChatConfig.type2,
          isConnectChat: true,
        ),
      ),
    ];
  }

  List<TabViewModel> get fmcgSupplierTabsList {
    return [
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 0
            ? Icon(Icons.chat)
            : Icon(Icons.chat_outlined),
        name: 'Chat',
        height: 20,
        page: const ChatListScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 1
            ? Icon(Icons.dashboard_outlined)
            : Icon(Icons.dashboard_outlined),
        name: 'Dashboard',
        height: 20,
        page: const DemoAuctionScreen(),
      ),
      // TabViewModel(
      //   icon: _appCubit.bottomNavIndex == 2
      //       ? Icon(Icons.person)
      //       : Icon(Icons.person_outline),
      //   name: 'My Account',
      //   height: 20,
      //   page: MyAccountScreen(),
      // ),
      // TabViewModel(
      //   icon:
      //       _appCubit.bottomNavIndex == 3 ? Icon(Icons.menu) : Icon(Icons.menu),
      //   name: 'More',
      //   height: 20,
      //   page: MoreOptionsScreen(),
      // ),
    ];
  }

  List<TabViewModel> get buyerTabsList {
    if (token == null) {
      return []; // or loader
    }
    return [
      TabViewModel(
          icon: _appCubit.bottomNavIndex == 0
              ? Icon(Icons.dashboard)
              : Icon(Icons.dashboard_outlined),
          name: 'Dashboard',
          height: 20,
          page: const BuyerDashboardScreen()),
      TabViewModel(
          icon: _appCubit.bottomNavIndex == 1
              ? Icon(Icons.article)
              : Icon(Icons.article_outlined),
          name: 'Negotiation',
          height: 20,
          page: const BuyerNegotiationScreen()),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 2
            ? Icon(Icons.person)
            : Icon(Icons.person_outline),
        name: 'My Account',
        height: 20,
        page: Constants.isAndroid14OrBelow && Platform.isAndroid
            ? InAppWebViewScreen(
                params: WebviewParams(
                    url:
                        "${EndPoints.buyerUrlWeb}/Account/MyAccountForAPI/$token",
                    canPop: false,
                    isAppBar: true,
                    isShowDrawer: true,
                    isShowNotification: true))
            : WebViewScreen(
                params: WebviewParams(
                    url:
                        "${EndPoints.buyerUrlWeb}/Account/MyAccountForAPI/$token",
                    canPop: false,
                    isAppBar: true,
                    isShowDrawer: true,
                    isShowNotification: true),
              ), // const OrdersScreen(),
      ),
      // TabViewModel(
      //   icon: _appCubit.bottomNavIndex == 2
      //       ? Icon(Icons.person)
      //       : Icon(Icons.person_outline),
      //   name: 'My Account',
      //   height: 20,
      //   page: BuyerMyAccountScreen(),
      // ),
      TabViewModel(
        icon:
            _appCubit.bottomNavIndex == 3 ? Icon(Icons.menu) : Icon(Icons.menu),
        name: 'More',
        height: 20,
        page: MoreOptionsScreen(),
      ),
    ];
  }

  Future<void> _loadToken() async {
    final secureStorage = SecureStorageService();
    final value = await secureStorage.read(AppStrings.apiVerificationCode);

    if (!mounted) return;

    setState(() {
      token = value ?? "";
    });
  }

  SecureStorageService secureStorage = SecureStorageService();

  // final GlobalKey<CupertinoTabEngineState> _tabEngineKey = GlobalKey();

  late final AnimationController _navAnimController;
  final GlobalKey<ScaffoldState> _sellerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _appCubit = BlocProvider.of<AppCubit>(context);
    _loadToken();
    nameUpdate();
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
    getTimezone();
    _appCubit.bottomNavIndex = 0;
    if (Constants.isBuyer != true) {
      _appCubit.onOpenSellerDrawer =
          () => _sellerScaffoldKey.currentState?.openDrawer();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<FirebaseNotificationService>().markAppShellReady();
    });

    super.initState();
  }

  void getTimezone() async {
    String timeZone = await secureStorage.read(AppStrings.sellerTimeZone) ?? "";

    if (timeZone == "" && Constants.isBuyer == true) {
      _appCubit.getCustomerDetailsById(NoParams());
    }
  }

  Future<void> nameUpdate() async {
    Constants.name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
            ? await secureStorage.read(AppStrings.customerName) ?? ""
            : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  void dispose() {
    _appCubit.onOpenSellerDrawer = null;
    _navAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          (previous != current && current is ChangeTab),
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (_appCubit.bottomNavIndex != 0) {
              _appCubit.changeTab(0);
              return;
            }

            SystemNavigator.pop();
            SystemNavigator.pop();
            if (state is CheckCustomerDetailsByIdSuccess) {
              await secureStorage.write(
                  AppStrings.sellerTimeZone, state.data.sellerTimeZone ?? "");
              Constants.timeZone = state.data.sellerTimeZone ?? "";
            }
          },
          child: AdaptiveScaffold(
            scaffoldKey:
                Constants.isBuyer != true ? _sellerScaffoldKey : null,
            drawer: Constants.isBuyer != true
                ? const SellerSideDrawer()
                : null,
            extendBodyBehindAppBar: true,
            body: Builder(
              builder: (_) {
                final tabs = Constants.isBuyer == true
                    ? buyerTabsList
                    : supplierTabsList;

                return KeyedSubtree(
                  key: ValueKey(_appCubit.bottomNavIndex),
                  child: tabs.isEmpty
                      ? const SizedBox.shrink()
                      : tabs[_appCubit.bottomNavIndex].page,
                );
              },
            ),
            bottomNavigationBar: CommonFloatingNavBar(
              index: _appCubit.bottomNavIndex,
              onTap: (i) {
                HapticFeedback.selectionClick();
                _appCubit.changeTab(i);
              },
              isSeller: Constants.isBuyer != true,
            ),
          ),
        );
      },
    );
  }
}

class CommonFloatingNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final bool isSeller;

  const CommonFloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
    this.isSeller = false,
  });

  static const Color _activeColor = Color(0xFF0A9FED);
  static const Color _inactiveColor = Colors.black87;

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
        children: isSeller ? _sellerItems() : _buyerItems(),
      ),
    );
  }

  List<Widget> _sellerItems() {
    return [
      _item(0, Icons.dashboard_outlined, 'Dashboard'),
      _item(1, Icons.description_outlined, 'Negotiation'),
      _item(
        2,
        Icons.play_circle_outline,
        'Demo',
        leading: Image.asset(
          'assets/images/demo_logo.png',
          width: 20,
          height: 20,
          color: index == 2 ? _activeColor : _inactiveColor,
        ),
      ),
      _item(
        3,
        Icons.support_agent_outlined,
        'Dedicated\nSupport',
        showOnlineDot: true,
      ),
    ];
  }

  List<Widget> _buyerItems() {
    return [
      _item(0, Icons.dashboard_outlined, 'Dashboard'),
      _item(1, Icons.description_outlined, 'Negotiation'),
      _item(2, Icons.person_outline, 'Account'),
      _item(3, Icons.menu_rounded, 'More'),
    ];
  }

  Widget _item(
    int i,
    IconData icon,
    String label, {
    Widget? leading,
    bool showOnlineDot = false,
  }) {
    final bool selected = i == index;

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
                color: _activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            leading ??
                Icon(
                  icon,
                  size: 20,
                  color: selected ? _activeColor : _inactiveColor,
                ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showOnlineDot) ...[
                  const BlinkingOnlineDot(size: 7),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? _activeColor : _inactiveColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
