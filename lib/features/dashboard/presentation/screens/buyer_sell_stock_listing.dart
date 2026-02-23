import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/auction_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/get_vendor_stock_list.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_vendor_stock_listing_usecase.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_dashboard_cards.dart';
import '../../../../injection_container.dart';

class BuyerSellStockListing extends StatefulWidget {
  const BuyerSellStockListing({super.key});

  @override
  State<BuyerSellStockListing> createState() => _BuyerSellStockListingState();
}

class _BuyerSellStockListingState extends State<BuyerSellStockListing> {
  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  final ScrollController _scrollController = ScrollController();
  SecureStorageService secureStorage = SecureStorageService();

  List<GetVendorStockList>? stockList;
  List<AuctionUnitList>? unitList;

  Future<void> getStockListing() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);
    await dashboardCubit.getReadyStockListing(GetVendorStockListingParams(
        token: token ?? '', requirementID: '', query: ''));
  }

  Future<void> getAuctionUnitList() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);
    await dashboardCubit.getAuctionUnit(token ?? '');
  }

  @override
  void initState() {
    getStockListing();
    getAuctionUnitList();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GetVendorStockListingSuccess) {
              stockList = state.data;
            }
            if (state is GetVendorStockListingError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is AddVendorStockEnquirySuccess) {}
            if (state is AddVendorStockEnquiryError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is GetAuctionUnitListSuccess) {
              unitList = state.data;
            }
            if (state is GetAuctionUnitListError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: AdaptiveScaffold(
        appBar: Constants.appBar(
          context,
          title: 'Sell Stock Listing',
          centerTitle: true,
          backgroundColor: AppColors.transparent,
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is GetVendorStockListingError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(onPress: getStockListing);
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: getStockListing,
                  errorText: state.failure.msg,
                );
              }
            }

            return Stack(
              children: [
                SafeArea(
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      if (state is GetVendorStockListingIsLoading)
                        const RiceShimmerSliver()
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverGrid(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              final item = stockList![index];

                              return RiceGridCard(
                                item: item,
                                onTap: () {},
                              );
                            }, childCount: stockList?.length ?? 0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.9,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RiceGridCard extends StatelessWidget {
  final GetVendorStockList item;
  final VoidCallback? onTap;

  const RiceGridCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: item.requirementId ?? "",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child:
                      // CachedNetworkImage(
                      //   imageUrl: item.vendorId.toString(),
                      //   fit: BoxFit.cover,
                      //   width: double.infinity,
                      // ),
                      CachedNetworkImage(
                    imageUrl: Uri.encodeFull(EndPoints.getImage(
                      item.commodityName?.replaceAll(" ", "-") ?? "",
                    )),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CommonLoader(),
                    errorWidget: (context, url, error) {
                      debugPrint("Image load failed: $error");
                      return const Icon(Icons.broken_image);
                    },
                    httpHeaders: const {
                      "Connection": "keep-alive",
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.commodityName ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff0B3D91),
              ),
            ),
            Text(
              item.locations ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xff0B3D91),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiceShimmerSliver extends StatelessWidget {
  const RiceShimmerSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 14, width: 80, color: Colors.white),
            ],
          ),
        ),
        childCount: 6,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9,
      ),
    );
  }
}
