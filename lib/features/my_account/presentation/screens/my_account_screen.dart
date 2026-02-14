import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/app/presentation/widgets/auto_refresh_mixin.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';

import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../injection_container.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
    with SingleTickerProviderStateMixin, TabAutoRefreshMixin {
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
  int get tabIndex => 2;

  @override
  void onTabActive() {
    getCompanyDetails(); // 🔥 auto refresh
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
  }

  bool _canOpenTab(int index) {
    // Membership Type tab index = 5
    if (index == 5 && companyDetails?.countryId == 0) {
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
            drawer: TradologieDrawer(),
            appBar: Constants.appBar(
              context,
              title: "My Account",
              centerTitle: true,
              height: 120,
              backgroundColor: AppColors.white,
              actions: [
                IconButton(
                    onPressed: () {
                      sl<NavigationService>().pushNamed(
                        Routes.notificationScreen,
                      );
                    },
                    icon: Icon(Icons.notifications)),
                SizedBox(width: 10),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  height: 48,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, // light background like image
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColors.primary, // selected pill color
                      borderRadius: BorderRadius.circular(30),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.blueGrey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    tabs: [
                      Tab(text: "Login Control"),
                      Tab(text: "Information"),
                      Tab(text: "Company Details"),
                      Tab(text: "Documents"),
                      Tab(text: "Authorized Person"),
                      Tab(text: "Legal Documents"),
                      Tab(text: "Bank Details"),
                      Tab(text: "Selling Location"),
                      Tab(text: "Bulk & Retail"),
                      Opacity(
                        opacity: companyDetails?.countryId == 0 ? 0.3 : 1,
                        child: Tab(text: "Membership Type"),
                      ),
                      Tab(text: "Commodity"),
                    ],
                  ),
                ),
              ),
            ),
            body: BlocBuilder<MyAccountCubit, MyAccountState>(
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
                          ), // InformationTab(),
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
                          ), // LoginControlTab(),
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
                          ), // CompanyDetailTab(),
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
                          ), // DocumentsTab(),
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
                          ), // AuthorizedPersonTab(),
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
                          ), // LegalDocumentsTab(),
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
                          ), // BankDetailsTab(),

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
                          ), // SellingLocationTab(),
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
                          ), // BulkAndRetailTab(),
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
                              ), // MembershipTab(),
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
                          ), //  CommodityTab(),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
