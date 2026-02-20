import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/app/presentation/widgets/custom_bottom_navigation_bar.dart';
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
        page: Constants.isBuyer == true
            ? const BuyerDashboardScreen()
            : const DashboardScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 1
            ? Icon(Icons.article)
            : Icon(Icons.article_outlined),
        name: 'Negotiations',
        height: 20,
        page: Constants.isBuyer == true
            ? const BuyerNegotiationScreen()
            : const NegotiationScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 2
            ? Icon(Icons.person)
            : Icon(Icons.person_outline),
        name: 'My Account',
        height: 20,
        page: Constants.isBuyer == true
            ? Constants.isAndroid14OrBelow && Platform.isAndroid
                ? InAppWebViewScreen(
                    params: WebviewParams(
                        url:
                            "${EndPoints.buyerUrlWeb}/Account/MyAccountForAPI/$token",
                        canPop: true,
                        isAppBar: true,
                        isShowDrawer: true,
                        isShowNotification: true))
                : WebViewScreen(
                    params: WebviewParams(
                        url:
                            "${EndPoints.buyerUrlWeb}/Account/MyAccountForAPI/$token",
                        canPop: true,
                        isAppBar: true,
                        isShowDrawer: true,
                        isShowNotification: true)) // const OrdersScreen(),
            : MyAccountScreen(),
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
        page: Constants.isBuyer == true
            ? const BuyerDashboardScreen()
            : const DashboardScreen(),
      ),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 1
            ? Icon(Icons.article)
            : Icon(Icons.article_outlined),
        name: 'Negotiations',
        height: 20,
        page: Constants.isBuyer == true
            ? const BuyerNegotiationScreen()
            : const NegotiationScreen(),
      ),
      // TabViewModel(
      //     icon: Icon(Icons.add_box_outlined),
      //     name: 'Add Negotiation',
      //     height: 20,
      //     page: const SupplierListScreen()),
      TabViewModel(
        icon: _appCubit.bottomNavIndex == 2
            ? Icon(Icons.person)
            : Icon(Icons.person_outline),
        name: 'My Account',
        height: 20,
        page: Constants.isBuyer == true
            ? Constants.isAndroid14OrBelow && Platform.isAndroid
                ? InAppWebViewScreen(
                    params: WebviewParams(
                        url:
                            "${EndPoints.buyerUrlWeb}/Account/MyAccountForAPI/$token",
                        canPop: true,
                        isAppBar: true,
                        isShowDrawer: true,
                        isShowNotification: true))
                : WebViewScreen(
                    params: WebviewParams(
                        url:
                            "${EndPoints.buyerUrlWeb}/Account/MyAccountForAPI/$token",
                        canPop: true,
                        isAppBar: true,
                        isShowDrawer: true,
                        isShowNotification: true)) // const OrdersScreen(),
            : MyAccountScreen(),
      ),
      // TabViewModel(
      //     icon: Icon(Icons.menu_outlined),
      //     name: 'More Options',
      //     height: 20,
      //     page: const MoreOptionsScreen()),
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
            appBar: Constants.appBar(context, height: 0, boxShadow: []),
            body: Stack(
              children: [
                Builder(
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
              ],
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              tabs:
                  Constants.isBuyer == true ? buyerTabsList : supplierTabsList,
              currentIndex: _appCubit.bottomNavIndex,
              onTap: (i) {
                HapticFeedback.selectionClick();
                _appCubit.changeTab(i);
              },
            ),
          ),
        );
      },
    );
  }
}
