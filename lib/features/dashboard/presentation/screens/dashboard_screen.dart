import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/dashboard_result.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

import '../widgets/dashboard_card.dart';
import '../../../app/presentation/screens/drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DashboardResult>? dashboardData;

  late PageController _pageController;
  int currentPage = 0;

  double _currentPageValue = 0.0;

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

  @override
  void initState() {
    super.initState();
    getDashboardData();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0.0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 4), _autoScroll);
    });
  }

  void _autoScroll() {
    if (!mounted) return;

    if (!_pageController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), _autoScroll);
      return;
    }

    final pageCount = _totalPages(context);
    currentPage = (currentPage + 1) % pageCount;

    _pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GetDashboardSuccess) {
              dashboardData = state.data;
            }
            if (state is GetDashboardError) {
              Constants.showFailureToast(state.failure);
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
                    Navigator.pushNamed(context, Routes.notificationScreen);
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
            return SafeArea(
              child: Column(
                children: [
                  Expanded(child: dashboardBody()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dashboardBody() {
    Responsive responsive = Responsive(context);
    if (dashboardData == null) {
      return CommonLoader();
    }

    final totalPages = _totalPages(context);

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            height: responsive.screenHeight * 0.75,
            child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, pageIndex) {
                  final perPage = responsive.isTablet ? 2 : 1;
                  final startIndex = pageIndex * perPage;
                  final endIndex =
                      (startIndex + perPage).clamp(0, dashboardData!.length);

                  final items = dashboardData!.sublist(startIndex, endIndex);

                  final distance = (_currentPageValue - pageIndex).abs();
                  final scale = (1 - distance * 0.08).clamp(0.92, 1.0);
                  final opacity = (1 - distance * 0.4).clamp(0.6, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Row(
                        children: items
                            .map(
                              (item) => Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: DashboardCard(item: item),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }),
          ),
        ),
        const SizedBox(height: 12),
        _pageDots(totalPages),
      ],
    );
  }

  Widget _pageDots(int totalPages) {
    const int maxVisibleDots = 10;

    // Calculate the start and end index of the visible dots
    int start = 0;
    int end = totalPages;

    if (totalPages > maxVisibleDots) {
      int middle = maxVisibleDots ~/ 2;

      if (currentPage <= middle) {
        start = 0;
        end = maxVisibleDots;
      } else if (currentPage >= totalPages - middle - 1) {
        start = totalPages - maxVisibleDots;
        end = totalPages;
      } else {
        start = currentPage - middle;
        end = currentPage + middle + 1;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(end - start, (i) {
        int pageIndex = start + i;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == pageIndex ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentPage == pageIndex
                ? AppColors.primary
                : AppColors.grayText,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
