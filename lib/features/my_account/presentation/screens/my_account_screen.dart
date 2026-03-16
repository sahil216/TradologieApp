import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../injection_container.dart';

class _MyAccountTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _MyAccountTabBarDelegate(this.child);

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _MyAccountTabBarDelegate oldDelegate) {
    return false;
  }
}

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
    with TickerProviderStateMixin {
  final SecureStorageService _secureStorage = SecureStorageService();
  String? token;
  CompanyDetails? companyDetails;
  late TabController _tabController;
  int _previousIndex = 0;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  Future<void> getCompanyDetails() async {
    await cubit.companyDetails(NoParams());
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    getCompanyDetails();
    Constants().checkAndroidVersion();
    _tabController = TabController(length: 11, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _handleTabChange(_tabController.index);
      }
    });
  }

  void _handleTabChange(int newIndex) {
    bool canOpen = _canOpenTab(newIndex);

    if (!canOpen) {
      Future.microtask(() {
        _tabController.index = _previousIndex;
      });
    } else {
      _previousIndex = newIndex;
    }
    _trackTabAnalytics(newIndex);
  }

  void _trackTabAnalytics(int index) {
    final tabName = [
      "Login Control",
      "Information",
      "Company Details",
      "Documents",
      "Authorized Person",
      "Legal Documents",
      "Bank Details",
      "Selling Location",
      "Bulk & Retail",
      "Membership Type",
      "Commodity",
    ][index];

    if (tabName == "Membership Type") {
      AnalyticsService.logEvent("membership_tab_clicked");
    }
    if (tabName == "Documents") {
      AnalyticsService.logEvent("documents_tab_clicked");
    }
  }

  bool _canOpenTab(int index) {
    if (index == 9 && companyDetails?.countryId == 0) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<void> _loadToken() async {
    final _token = await _secureStorage.read(AppStrings.apiVerificationCode);
    setState(() {
      token = _token;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return const AdaptiveScaffold(
        body: CommonLoader(),
      );
    }

    return DefaultTabController(
      length: 11,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MyAccountCubit, MyAccountState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is CompanyDetailsSuccess) {
                companyDetails = state.data;
              }
              if (state is CompanyDetailsError) {
                CommonToast.showFailureToast(state.failure);
              }
            },
          ),
        ],
        child: AdaptiveScaffold(
          // drawer: TradologieDrawer(),
          // appBar: Constants.appBar(
          //   context,
          //   title: "My Account",
          //   centerTitle: true,
          //   height: 120,
          //   backgroundColor: AppColors.white,
          //   actions: [
          //     IconButton(
          //         onPressed: () {
          //           sl<NavigationService>().pushNamed(
          //             Routes.notificationScreen,
          //           );
          //         },
          //         icon: Icon(Icons.notifications)),
          //     SizedBox(width: 10),
          //   ],
          //   bottom: PreferredSize(
          //     preferredSize: const Size.fromHeight(60),
          //     child: Container(
          //       height: 48,
          //       margin:
          //           const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //       padding: const EdgeInsets.all(4),
          //       decoration: BoxDecoration(
          //         color: Colors.blue.shade50, // light background like image
          //         borderRadius: BorderRadius.circular(30),
          //       ),
          //       child: TabBar(
          //         isScrollable: true,
          //         controller: _tabController,
          //         dividerColor: Colors.transparent,
          //         indicator: BoxDecoration(
          //           color: AppColors.primary, // selected pill color
          //           borderRadius: BorderRadius.circular(30),
          //         ),
          //         indicatorSize: TabBarIndicatorSize.tab,
          //         labelColor: Colors.white,
          //         unselectedLabelColor: Colors.blueGrey,
          //         labelStyle: const TextStyle(
          //           fontWeight: FontWeight.w600,
          //           fontSize: 15,
          //         ),
          //         unselectedLabelStyle: const TextStyle(
          //           fontWeight: FontWeight.w500,
          //           fontSize: 15,
          //         ),
          //         tabs: [
          //           Tab(text: "Login Control"),
          //           Tab(text: "Information"),
          //           Tab(text: "Company Details"),
          //           Tab(text: "Documents"),
          //           Tab(text: "Authorized Person"),
          //           Tab(text: "Legal Documents"),
          //           Tab(text: "Bank Details"),
          //           Tab(text: "Selling Location"),
          //           Tab(text: "Bulk & Retail"),
          //           Opacity(
          //             opacity: companyDetails?.countryId == 0 ? 0.3 : 1,
          //             child: Tab(text: "Membership Type"),
          //           ),
          //           Tab(text: "Commodity"),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          body: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              /// ⭐ ULTRA COMMON APPBAR
              CommonAppbar(
                title: "My Account",
                showNotification: true,
                onNotificationTap: () {
                  sl<NavigationService>().pushNamed(
                    Routes.notificationScreen,
                  );
                },
              ),

              /// ⭐ PINNED TABBAR (EXACT SAME UI)
              SliverPersistentHeader(
                pinned: true,
                delegate: _MyAccountTabBarDelegate(
                  CommonTabBarWidget(
                    controller: _tabController,
                    tabs: const [
                      "Login Control",
                      "Information",
                      "Company Details",
                      "Documents",
                      "Authorized Person",
                      "Legal Documents",
                      "Bank Details",
                      "Selling Location",
                      "Bulk & Retail",
                      "Membership Type",
                      "Commodity",
                    ],
                    isEnabled: (index) {
                      if (index == 9 && companyDetails?.countryId == 0) {
                        return false;
                      }
                      return true;
                    },
                  ),
                ),
              ),
              SliverFillRemaining(
                child: BlocBuilder<MyAccountCubit, MyAccountState>(
                  buildWhen: (previous, current) {
                    bool result = previous != current;
                    result = result &&
                        (current is CompanyDetailsSuccess ||
                            current is CompanyDetailsError ||
                            current is CompanyDetailsIsLoading);
                    return result;
                  },
                  builder: (context, state) {
                    if (state is CompanyDetailsError) {
                      if (state.failure is NetworkFailure) {
                        return CustomErrorNetworkWidget(
                          onPress: () {
                            getCompanyDetails();
                          },
                        );
                      } else if (state.failure is UserFailure) {
                        return CustomErrorWidget(
                          onPress: () {
                            getCompanyDetails();
                          },
                          errorText: state.failure.msg,
                        );
                      }
                    }

                    /// 👇 KEEP YOUR ORIGINAL TABBARVIEW EXACTLY SAME
                    return TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorLoginControlForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorLoginControlForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // LoginControlTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorAddForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorAddForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // InformationTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorCompanyDetailForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorCompanyDetailForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // CompanyDetailTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorDocumentForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorDocumentForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // DocumentsTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorAuthorizedPersonForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorAuthorizedPersonForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // AuthorizedPersonTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorLegalDocsForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorLegalDocsForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // LegalDocumentsTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorBankDetailForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorBankDetailForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // BankDetailsTab(),

                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorSellingLocationForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/VendorSellingLocationForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // SellingLocationTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/BulkRetailForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/BulkRetailForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // BulkAndRetailTab(),
                        companyDetails?.countryId == 0
                            ? Container()
                            : Constants.isAndroid14OrBelow && Platform.isAndroid
                                ? InAppWebViewScreen(
                                    params: WebviewParams(
                                      isAppBar: false,
                                      canPop: true,
                                      url: Uri.parse(
                                              "${EndPoints.supplierImageurl}/supplier/MembershipTypeDetailForAPI.aspx?")
                                          .replace(
                                        queryParameters: {
                                          "Token": token,
                                        },
                                      ).toString(),
                                    ),
                                  )
                                : WebViewScreen(
                                    params: WebviewParams(
                                      isAppBar: false,
                                      canPop: true,
                                      url: Uri.parse(
                                              "${EndPoints.supplierImageurl}/supplier/MembershipTypeDetailForAPI.aspx?")
                                          .replace(
                                        queryParameters: {
                                          "Token": token,
                                        },
                                      ).toString(),
                                    ),
                                  ),
                        // MembershipTab(),
                        Constants.isAndroid14OrBelow && Platform.isAndroid
                            ? InAppWebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/CommodityForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              )
                            : WebViewScreen(
                                params: WebviewParams(
                                  isAppBar: false,
                                  canPop: true,
                                  url: Uri.parse(
                                          "${EndPoints.supplierImageurl}/supplier/CommodityForAPI.aspx?")
                                      .replace(
                                    queryParameters: {
                                      "Token": token,
                                    },
                                  ).toString(),
                                ),
                              ),
                        // CommodityTab(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 70,
          ),
        ),
      ),
    );
  }
}

class CommonTabBarWidget extends StatefulWidget {
  final TabController controller;
  final List<String> tabs;
  final bool Function(int index)? isEnabled;

  const CommonTabBarWidget({
    super.key,
    required this.controller,
    required this.tabs,
    this.isEnabled,
  });

  @override
  State<CommonTabBarWidget> createState() => _CommonTabBarWidgetState();
}

class _CommonTabBarWidgetState extends State<CommonTabBarWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();
    _keys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
    widget.controller.addListener(_centerSelectedTab);
  }

  void _centerSelectedTab() {
    if (!_scrollController.hasClients) return;

    final index = widget.controller.index;
    final ctx = _keys[index].currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);

    final screenWidth = MediaQuery.of(context).size.width;
    final target = _scrollController.offset +
        pos.dx -
        screenWidth / 2 +
        box.size.width / 2;

    _scrollController.animateTo(
      target.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_centerSelectedTab);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller.animation!,
      builder: (context, _) {
        final progress = widget.controller.animation!.value;

        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white.withValues(alpha: .5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              /// ⭐ SHADER EDGE FADE (NO OVERLAY BLOCKS)
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.tabs.length,
                itemBuilder: (context, index) {
                  final selected = widget.controller.index == index;
                  final enabled = widget.isEnabled?.call(index) ?? true;

                  final stretch =
                      (1 - (progress - index).abs()).clamp(0.9, 1.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: enabled
                          ? () => widget.controller.animateTo(index)
                          : null,
                      child: Transform.scale(
                        scale: stretch,
                        child: AnimatedContainer(
                          key: _keys[index],
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Opacity(
                            opacity: enabled ? 1 : .3,
                            child: Text(
                              widget.tabs[index],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
