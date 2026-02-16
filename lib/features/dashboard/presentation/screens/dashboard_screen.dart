import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:tradologie_app/features/app/presentation/widgets/auto_refresh_mixin.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/dashboard_result.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

import '../../../../injection_container.dart';
import '../widgets/dashboard_card.dart';
import '../../../app/presentation/screens/drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashboardResult>? dashboardData;

  late final PageController _carouselController;
  int currentPage = 0;

  late AppCubit _appCubit;

  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  int _totalPages(BuildContext context) {
    Responsive responsive = Responsive(context);
    if (dashboardData == null || dashboardData!.isEmpty) return 0;

    final perPage = responsive.isTablet ? 2 : 1;
    return (dashboardData!.length / perPage).ceil();
  }

  Future<void> getDashboardData() async {
    SecureStorageService secureStorage = SecureStorageService();
    GetDashboardParams params = GetDashboardParams(
        token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "");
    await dashboardCubit.getDashboardData(params);
  }

  // @override
  // int get tabIndex => 0;

  // @override
  // void onTabActive() {
  //   getDashboardData();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Future.delayed(const Duration(seconds: 4), _autoScroll);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getDashboardData();
    _appCubit = BlocProvider.of<AppCubit>(context);
    _carouselController = PageController(viewportFraction: 0.88);
    // _pageController.addListener(() {
    //   setState(() {
    //     _currentPageValue = _pageController.page ?? 0.0;
    //   });
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), _autoScroll);
    });
  }

  void _autoScroll() {
    if (!mounted) return;
    if (!_carouselController.hasClients) return;

    final pageCount = _totalPages(context);

    if (pageCount <= 1) {
      Future.delayed(const Duration(seconds: 4), _autoScroll);
      return;
    }

    currentPage = (currentPage + 1) % pageCount;

    _carouselController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  void dispose() {
    // _carouselController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _totalPages(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GetDashboardSuccess) {
              dashboardData = state.data;
              setState(() {});
            }
            if (state is GetDashboardError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: AdaptiveScaffold(
        drawer: const TradologieDrawer(),
        appBar: Constants.appBar(context,
            title: 'Dashboard',
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    sl<NavigationService>().pushNamed(
                      Routes.notificationScreen,
                    );
                  },
                  icon: Icon(Icons.notifications)),
              SizedBox(width: 10),
            ]),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          buildWhen: (previous, current) {
            bool result = previous != current;
            result = result &&
                (current is GetDashboardSuccess ||
                    current is GetDashboardError ||
                    current is GetDashboardIsLoading);
            return result;
          },
          builder: (context, state) {
            if (state is GetDashboardIsLoading) {
              return const CommonLoader();
            }
            if (dashboardData == null) {
              if (state is GetDashboardError) {
                if (state.failure is NetworkFailure) {
                  return CustomErrorNetworkWidget(
                    onPress: () {
                      getDashboardData();
                    },
                  );
                } else if (state.failure is UserFailure) {
                  return CustomErrorWidget(
                    onPress: () {
                      getDashboardData();
                    },
                    errorText: state.failure.msg,
                  );
                }
              }
              return const CommonLoader();
            }
            return SizedBox(
              height: Responsive(context).screenHeight * 0.72,
              child: DashboardCarausel(
                data: dashboardData!,
                onParticipate: (_) => _appCubit.changeTab(1),
                controller: _carouselController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            );
          },
        ),
        bottomNavigationBar: dashboardData != null && dashboardData!.length > 1
            ? PageDots(
                controller: _carouselController,
                itemCount: dashboardData!.length,
              )
            : const SizedBox.shrink(), // _pageDots(totalPages),
      ),
    );
  }
}

class DashboardCarausel extends StatefulWidget {
  final List<DashboardResult> data;
  final Function(DashboardResult) onParticipate;
  final PageController controller;
  final ValueChanged<int>? onPageChanged;

  const DashboardCarausel({
    super.key,
    required this.data,
    required this.onParticipate,
    required this.controller,
    this.onPageChanged,
  });

  @override
  State<DashboardCarausel> createState() => _DashboardCarauselState();
}

class _DashboardCarauselState extends State<DashboardCarausel> {
  @override
  void initState() {
    super.initState();

    /// 👇 Side preview like AppStore cards
    // widget.controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.controller,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.data.length,
      onPageChanged: (index) {
        widget.onPageChanged?.call(index);
      },
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: widget.controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: DashboardCard(
              item: widget.data[index],
              onParticipateNowPressed: () =>
                  widget.onParticipate(widget.data[index]),
            ),
          ),
          builder: (context, child) {
            double page = 0;

            if (widget.controller.hasClients &&
                widget.controller.page != null) {
              page = widget.controller.page!;
            } else {
              page = index.toDouble();
            }

            /// 🔥 Distance from center page
            final distance = (page - index);

            /// ✅ Scale
            final scale =
                (1 - (distance.abs() * 0.12)).clamp(0.86, 1.0).toDouble();

            /// ✅ Opacity
            final opacity =
                (1 - (distance.abs() * 0.4)).clamp(0.6, 1.0).toDouble();

            /// 🚀 3D Perspective Tilt
            final tilt = (distance * 0.08);

            /// 🌑 Dynamic shadow depth
            final shadowBlur =
                (20 * (1 - distance.abs())).clamp(4, 20).toDouble();

            return Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(tilt),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: shadowBlur,
                            color: Colors.black.withValues(alpha: .12),
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PageDots extends StatelessWidget {
  final PageController controller;
  final int itemCount;

  const PageDots({
    super.key,
    required this.controller,
    required this.itemCount,
  });

  static const int maxVisibleDots = 9;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        double page = 0;

        if (controller.hasClients && controller.page != null) {
          page = controller.page!;
        } else {
          page = controller.initialPage.toDouble();
        }

        int currentIndex = page.round();

        /// ✅ calculate visible window
        int start = 0;
        int end = itemCount;

        if (itemCount > maxVisibleDots) {
          int half = maxVisibleDots ~/ 2;

          if (currentIndex <= half) {
            start = 0;
            end = maxVisibleDots;
          } else if (currentIndex >= itemCount - half - 1) {
            start = itemCount - maxVisibleDots;
            end = itemCount;
          } else {
            start = currentIndex - half;
            end = currentIndex + half + 1;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(end - start, (i) {
            int index = start + i;

            final distance = (page - index).abs();

            /// 🔥 liquid width animation
            final width = (26 * (1 - distance)).clamp(6, 26).toDouble();

            final opacity = (1 - distance).clamp(0.35, 1.0).toDouble();

            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: width,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        );
      },
    );
  }
}
