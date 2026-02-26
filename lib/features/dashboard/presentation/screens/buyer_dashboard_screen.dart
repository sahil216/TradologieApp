import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_banner_engine.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_dashboard_cards.dart';
import 'package:tradologie_app/features/webview/presentation/screens/in_app_webview_screen.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/features/webview/presentation/screens/webview_screen.dart';
import '../../../../injection_container.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  final ScrollController _scrollController = ScrollController();

  final ScrollController _scroll = ScrollController();

  Future<void> getCommodityData() async {
    await dashboardCubit.getCommodityList(NoParams());
  }

  int index = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      // drawer: const TradologieDrawer(),
      // appBar: Constants.appBar(
      //   context,
      //   title: 'Dashboard',
      //   centerTitle: false,
      //   backgroundColor: AppColors.transparent,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         sl<NavigationService>().pushNamed(Routes.notificationScreen);
      //       },
      //       icon: const Icon(Icons.notifications),
      //     ),
      //     const SizedBox(width: 10),
      //   ],
      // ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is GetDashboardIsLoading) {
            return const CommonLoader();
          }

          if (state is GetCommodityListError) {
            if (state.failure is NetworkFailure) {
              return CustomErrorNetworkWidget(onPress: getCommodityData);
            } else if (state.failure is UserFailure) {
              return CustomErrorWidget(
                onPress: getCommodityData,
                errorText: state.failure.msg,
              );
            }
          }

          return Stack(
            children: [
              SafeArea(
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CommonAppbar(
                      title: "Dashboard",
                      showBackButton: false,
                      showNotification: true,
                    ),
                    const SliverToBoxAdapter(
                      child: BuyerDashboardBannerEngine(
                        banners: [
                          AppBanner(
                            image:
                                "https://www.tradologie.com/DOCS/mobileapp/buyerdashboard-1.webp",
                            title: "Source Quality\nBuy Globally",
                            subtitle: "B2B Marketplace",
                          ),
                          AppBanner(
                            image:
                                "https://www.tradologie.com/DOCS/mobileapp/buyerdashboard-2.webp",
                            title: "Trade Smart\nTrade Fast",
                            subtitle: "Global Suppliers",
                          ),
                          AppBanner(
                            image:
                                "https://www.tradologie.com/DOCS/mobileapp/buyerdashboard-3.webp",
                            title: "Trade Smart\nTrade Fast",
                            subtitle: "Global Suppliers",
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    // SliverPadding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   sliver: SliverToBoxAdapter(
                    //     child: InkWell(
                    //       onTap: () {
                    //         Constants.isAndroid14OrBelow && Platform.isAndroid
                    //             ? InAppWebViewScreen(
                    //                 params: WebviewParams(
                    //                     url: "https://www.tradologie.com/fmcg/",
                    //                     canPop: false,
                    //                     isAppBar: true,
                    //                     isShowDrawer: true,
                    //                     isShowNotification: true))
                    //             : WebViewScreen(
                    //                 params: WebviewParams(
                    //                     url: "https://www.tradologie.com/fmcg/",
                    //                     canPop: false,
                    //                     isAppBar: true,
                    //                     isShowDrawer: true,
                    //                     isShowNotification: true));
                    //       },
                    //       child: CachedNetworkImage(
                    //         imageUrl:
                    //             "https://www.tradologie.com/DOCS/mobileapp/buyerdashboard-1.webp",
                    //       ),
                    //     ),
                    // BuyerDashboardBannerEngine(
                    //   banners: [
                    //     AppBanner(
                    //       image:
                    //           "https://www.tradologie.com/DOCS/mobileapp/buyerdashboard-1.webp",
                    //       title: "FMCG",
                    //       subtitle: "Coming Soon",
                    //     ),
                    //   ],
                    //   onTap: (banner, index) {
                    //     Constants.isAndroid14OrBelow && Platform.isAndroid
                    //         ? InAppWebViewScreen(
                    //             params: WebviewParams(
                    //                 url: "https://www.tradologie.com/fmcg/",
                    //                 canPop: false,
                    //                 isAppBar: true,
                    //                 isShowDrawer: true,
                    //                 isShowNotification: true))
                    //         : WebViewScreen(
                    //             params: WebviewParams(
                    //                 url: "https://www.tradologie.com/fmcg/",
                    //                 canPop: false,
                    //                 isAppBar: true,
                    //                 isShowDrawer: true,
                    //                 isShowNotification: true));
                    //   },
                    // ),
                    //   ),
                    // ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                          child: Row(
                        children: [
                          Expanded(
                            child: BuyerDashboardCard(
                              color: Colors.blue,
                              icon: Icons.description,
                              title: "Post Your\nRequirement",
                              subtitle:
                                  "Submit requirement and receive quotes from verified suppliers.",
                              onTap: () {
                                sl<NavigationService>().pushNamed(
                                    Routes.buyerPostRequirementRoute);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: BuyerDashboardCard(
                              color: Colors.deepOrange,
                              icon: Icons.inventory_2,
                              title: "Ready to Sell\nStock",
                              subtitle:
                                  "View seller ready stock and send enquiries directly to them",
                              onTap: () {
                                sl<NavigationService>()
                                    .pushNamed(Routes.buyerSellStockListing);
                              },
                            ),
                          ),
                        ],
                      )),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                          child: Row(
                        children: [
                          Expanded(
                            child: BuyerDashboardCard(
                              color: Colors.lightGreen,
                              icon: Icons.add,
                              title: "Create Negotiation",
                              subtitle:
                                  "Start a live negotiation with verified suppliers and finalize best price.",
                              onTap: () {
                                sl<NavigationService>()
                                    .pushNamed(Routes.supplierListScreen);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Spacer()
                          // Expanded(
                          //   child: BuyerDashboardCard(
                          //     color: Colors.brown,
                          //     icon: Icons.add,
                          //     title: "FMCG\n",
                          //     subtitle: "Coming soon\n \n",
                          //     onTap: () {
                          //       Constants.isAndroid14OrBelow &&
                          //               Platform.isAndroid
                          //           ? Navigator.pushNamed(
                          //               context, Routes.inAppWebViewRoute,
                          //               arguments: WebviewParams(
                          //                   url:
                          //                       "https://www.tradologie.com/fmcg/",
                          //                   canPop: true,
                          //                   isAppBar: true,
                          //                   isShowDrawer: false,
                          //                   isShowNotification: false))
                          //           : Navigator.pushNamed(
                          //               context, Routes.webViewRoute,
                          //               arguments: WebviewParams(
                          //                   url:
                          //                       "https://www.tradologie.com/fmcg/",
                          //                   canPop: true,
                          //                   isAppBar: true,
                          //                   isShowDrawer: false,
                          //                   isShowNotification: false));
                          //     },
                          //   ),
                          // ),
                        ],
                      )),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 110)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
