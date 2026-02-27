import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/contact_us/more_options_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/my_account_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/buyer_negotiation_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/negotiation_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

import '../../../../core/utils/constants.dart';
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
        name: 'Negotiations',
        height: 20,
        page: const NegotiationScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 2
            ? Icon(Icons.person)
            : Icon(Icons.person_outline),
        name: 'My Account',
        height: 20,
        page: MyAccountScreen(),
      ),
      TabViewModel(
        icon:
            _appCubit.bottomNavIndex == 3 ? Icon(Icons.menu) : Icon(Icons.menu),
        name: 'More',
        height: 20,
        page: MoreOptionsScreen(),
      ),
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
          name: 'Negotiations',
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
                      isShowNotification: true)) // const OrdersScreen(),

          ),
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

    super.initState();
  }

  void getTimezone() async {
    String timeZone = await secureStorage.read(AppStrings.sellerTimeZone) ?? "";

    if (timeZone == "" && Constants.isBuyer == true) {
      _appCubit.getCustomerDetailsById(NoParams());
    }
  }

  Future<void> nameUpdate() async {
    Constants.name = Constants.isBuyer == true
        ? await secureStorage.read(AppStrings.customerName) ?? ""
        : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  void dispose() {
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
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                /// 🔥 CURRENT PAGE
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: true,
                      child: Builder(
                        builder: (_) {
                          final tabs = Constants.isBuyer == true
                              ? buyerTabsList
                              : supplierTabsList;

                          return KeyedSubtree(
                            key: ValueKey(_appCubit.bottomNavIndex),
                            child: tabs[_appCubit.bottomNavIndex].page,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                /// 💎 ULTRA FLOATING NAVBAR V5
                CommonFloatingNavBar(
                  index: _appCubit.bottomNavIndex,
                  onTap: (i) {
                    HapticFeedback.selectionClick();
                    _appCubit.changeTab(i);
                  },
                ),
              ],
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

  const CommonFloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .75),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withValues(alpha: .08),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(0, Icons.dashboard_outlined, "Dashboard"),
                _item(1, Icons.description_outlined, "Negotiations"),
                _item(2, Icons.person_outline, "Account"),
                _item(3, Icons.menu, "More"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, IconData icon, String label) {
    final bool active = i == index;

    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? Colors.white : Colors.black54,
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
