import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';

import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/buyer_dashboard_screen.dart';
import 'package:tradologie_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/my_account_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/buyer_negotiation_screen.dart';
import 'package:tradologie_app/features/negotiation/presentation/screens/negotiation_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

import '../../../../core/utils/app_colors.dart';
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

  List<TabViewModel> get _firstListTab {
    if (token == null) {
      return []; // or loader
    }
    return [
      TabViewModel(
        icon: Icon(Icons.dashboard_outlined),
        name: 'Dashboard',
        height: 26,
        page: Constants.isBuyer == true
            ? const BuyerDashboardScreen()
            : const DashboardScreen(),
      ),
      TabViewModel(
        icon: Icon(Icons.article_outlined),
        name: 'Negotiations',
        height: 20,
        page: Constants.isBuyer == true
            ? const BuyerNegotiationScreen()
            : const NegotiationScreen(),
      ),
      TabViewModel(
        icon: Icon(Icons.person),
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

  Future<void> _loadToken() async {
    final secureStorage = SecureStorageService();
    final value = await secureStorage.read(AppStrings.apiVerificationCode);

    if (!mounted) return;

    setState(() {
      token = value ?? "";
    });
  }

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

    super.initState();
  }

  Future<void> nameUpdate() async {
    SecureStorageService secureStorage = SecureStorageService();
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
          canPop: _appCubit.bottomNavIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (_appCubit.bottomNavIndex != 0) {
              _appCubit.changeTab(0);
            }
          },
          child: AdaptiveScaffold(
            appBar: Constants.appBar(context, height: 0, boxShadow: []),
            body: Stack(
              children: [
                PageView(
                  controller: _appCubit.controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ..._firstListTab.map((e) => e.page),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: SizedBox(
                    height: 80,
                    child: Center(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _navAnimController,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 12,
                              sigmaY: 12,
                            ),
                            child: Container(
                              height: 76,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: buildAnimatedTabs(), // icons + bubble
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildAnimatedTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ..._firstListTab.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isActive = _appCubit.bottomNavIndex == index;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isActive) return;
                HapticFeedback.lightImpact();
                _appCubit.changeTab(index);
              },
              child: AnimatedScale(
                scale: isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'tab_${item.name}',
                      child: Icon(
                        (item.icon as Icon).icon,
                        size: 26,
                        color:
                            isActive ? AppColors.primary : AppColors.grayText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      style: TextStyleConstants.medium(
                        context,
                        fontSize: isActive ? 13 : 12,
                        color:
                            isActive ? AppColors.primary : AppColors.grayText,
                      ),
                      child: Text(item.name),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
