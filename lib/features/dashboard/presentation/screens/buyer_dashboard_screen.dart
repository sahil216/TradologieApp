import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
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
  String? _openedWidget;

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
              Positioned.fill(child: _parallaxBg()),
              SafeArea(
                child: CustomScrollView(
                  controller: _scroll,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 14)),
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
                                  "Request quotes from verified suppliers",
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
                              subtitle: "List your inventory for buyer",
                              onTap: () {
                                sl<NavigationService>()
                                    .pushNamed(Routes.buyerSellStockListing);
                              },
                            ),
                          ),
                        ],
                      )),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
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
