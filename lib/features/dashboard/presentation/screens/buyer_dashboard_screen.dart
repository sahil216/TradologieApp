import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
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
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import '../../../../injection_container.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen>
    with SingleTickerProviderStateMixin {
  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  final ScrollController _scrollController = ScrollController();

  final ScrollController _scroll = ScrollController();
  double depth = 0;
  double pointerX = 0;
  double pointerY = 0;

  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  Future<void> getCommodityData() async {
    await dashboardCubit.getCommodityList(NoParams());
  }

  int index = 0;
  @override
  void initState() {
    super.initState();

    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenFade = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    );

    _screenScale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    _screenSlide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _screenController.forward();
    });
  }

  @override
  void dispose() {
    _screenController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
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
                child: Listener(
                  onPointerMove: (e) {
                    final size = MediaQuery.of(context).size;
                    setState(() {
                      pointerX = ((e.position.dx / size.width) - .5) * 2;
                      pointerY = ((e.position.dy / size.height) - .5) * 2;
                    });
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scroll) {
                      final velocity = scroll is ScrollUpdateNotification
                          ? scroll.scrollDelta ?? 0
                          : 0;
                      setState(() {
                        depth = (velocity / 30).clamp(-1.0, 1.0);
                      });
                      return false;
                    },
                    child: FadeTransition(
                      opacity: _screenFade,
                      child: SlideTransition(
                        position: _screenSlide,
                        child: ScaleTransition(
                          scale: _screenScale,
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
                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 16)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                sliver: SliverToBoxAdapter(
                                  child: Row(children: [
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
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: BuyerDashboardCard(
                                        color: Colors.deepOrange,
                                        icon: Icons.inventory_2,
                                        title: "Ready to Sell\nStock",
                                        subtitle:
                                            "View seller ready stock and send enquiries directly to them",
                                        onTap: () {
                                          sl<NavigationService>().pushNamed(
                                              Routes.buyerSellStockListing);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: BuyerDashboardCard(
                                        color: Colors.lightGreen,
                                        icon: Icons.add,
                                        title: "Create Negotiation",
                                        subtitle:
                                            "Start a live negotiation with verified suppliers and finalize best price.",
                                        onTap: () {
                                          sl<NavigationService>().pushNamed(
                                              Routes.supplierListScreen);
                                        },
                                      ),
                                    ),
                                  ]),
                                ),
                              ),

                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 16)),
                              SliverToBoxAdapter(
                                child: BuyerDashboardBannerEngine(
                                  onTap: (banner, index) {
                                    Constants.isAndroid14OrBelow &&
                                            Platform.isAndroid
                                        ? Navigator.pushNamed(
                                            context, Routes.inAppWebViewRoute,
                                            arguments: WebviewParams(
                                                url:
                                                    "https://www.tradologie.com/fmcg-view",
                                                canPop: true,
                                                isAppBar: true,
                                                isShowDrawer: false,
                                                isShowNotification: false))
                                        : Navigator.pushNamed(
                                            context, Routes.webViewRoute,
                                            arguments: WebviewParams(
                                                url:
                                                    "https://www.tradologie.com/fmcg-view",
                                                canPop: true,
                                                isAppBar: true,
                                                isShowDrawer: false,
                                                isShowNotification: false));
                                  },
                                  banners: [
                                    AppBanner(
                                      image:
                                          "https://www.tradologie.com/DOCS/mobileapp/fmcg-banner.webp",
                                      title:
                                          "Source FMCG Products in Bulk from Verified Global Suppliers",
                                      subtitle: "",
                                    ),
                                  ],
                                ),
                              ),

                              const SliverToBoxAdapter(
                                  child: SizedBox(height: 110)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedReveal extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedReveal({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedReveal> createState() => _AnimatedRevealState();
}

class _AnimatedRevealState extends State<_AnimatedReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: 120 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
