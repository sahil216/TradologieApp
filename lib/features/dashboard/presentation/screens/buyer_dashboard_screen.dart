import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_banner_engine.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_dashboard_cards.dart';
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      drawer: const TradologieDrawer(),
      appBar: Constants.appBar(
        context,
        title: 'Dashboard',
        centerTitle: false,
        backgroundColor: AppColors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              sl<NavigationService>().pushNamed(Routes.notificationScreen);
            },
            icon: const Icon(Icons.notifications),
          ),
          const SizedBox(width: 10),
        ],
      ),
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
              // Positioned.fill(child: _parallaxBg()),
              SafeArea(
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
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
                                  "Create a negotiation with a supplier and get quotes.",
                              onTap: () {
                                sl<NavigationService>()
                                    .pushNamed(Routes.supplierListScreen);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Spacer(),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _parallaxBg() {
    return AnimatedBuilder(
      animation: _scroll,
      builder: (_, __) {
        double offset = _scroll.hasClients ? _scroll.offset * .15 : 0;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffF7FBFF),
                  Color(0xffEAF4FF),
                  Color(0xffDCEEFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        );
      },
    );
  }
}
