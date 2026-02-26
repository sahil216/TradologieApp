import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/auction_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/get_vendor_stock_list.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_vendor_stock_enquiry_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_vendor_stock_listing_usecase.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class BuyerSellStockListing extends StatefulWidget {
  const BuyerSellStockListing({super.key});

  @override
  State<BuyerSellStockListing> createState() => _BuyerSellStockListingState();
}

class _BuyerSellStockListingState extends State<BuyerSellStockListing> {
  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  final ScrollController _scrollController = ScrollController();
  SecureStorageService secureStorage = SecureStorageService();

  AuthenticationCubit get authenticationCubit =>
      BlocProvider.of<AuthenticationCubit>(context);

  List<GetVendorStockList>? stockList;
  List<AuctionUnitList>? unitList;
  List<CountryCodeList>? countryCodeList;
  AuctionUnitList? selectedUnit;
  CountryCodeList? selectedCountryCode;

  TextEditingController quantityController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> getStockListing() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);
    await dashboardCubit.getReadyStockListing(GetVendorStockListingParams(
        token: token ?? '', requirementID: '', query: ''));
  }

  Future<void> getAuctionUnitList() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);
    await dashboardCubit.getAuctionUnit(token ?? '');
  }

  Key unitKey = UniqueKey();
  List<AuctionUnitList> fetchItemUnit(String filter, LoadProps? loadProps) {
    final allItems = unitList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.unitName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<CountryCodeList> fetchCountryCode(String filter, LoadProps? loadProps) {
    final allItems = countryCodeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.countryName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    getStockListing();
    getAuctionUnitList();
    authenticationCubit.getCountryCodeList(NoParams());
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
            if (state is AddVendorStockEnquirySuccess) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
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
        BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GetCountryCodeListSuccess) {
              countryCodeList = state.data;
              selectedCountryCode = countryCodeList
                  ?.firstWhere((element) => element.countryCode == "91");
              setState(() {});
            }
            if (state is GetCountryCodeListError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: AdaptiveScaffold(
        // appBar: Constants.appBar(
        //   context,
        //   title: 'Ready to Sell Stock',
        //   centerTitle: true,
        //   backgroundColor: AppColors.transparent,
        // ),
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
                      const CommonAppbar(
                        title: "Ready to Sell Stock",
                        showBackButton: true,
                      ),
                      if (state is GetVendorStockListingIsLoading ||
                          state is GetAuctionUnitListIsLoading)
                        const RiceShimmerSliver()
                      else
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = stockList?[index];
                                return categoryUltraCard(
                                  item: item,
                                  heroTag: "category_$index",
                                );
                              },
                              childCount: stockList?.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 14,
                              childAspectRatio: .80,
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

  Widget categoryUltraCard(
      {GetVendorStockList? item, required String heroTag}) {
    return Hero(
      tag: heroTag,
      transitionOnUserGestures: true,
      flightShuttleBuilder:
          (flightContext, animation, direction, fromContext, toContext) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return AnimatedBuilder(
          animation: curved,
          child: toContext.widget,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + (0.04 * curved.value), // subtle pop
              child: child,
            );
          },
        );
      },
      child: RepaintBoundary(
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(16),
          elevation: 3,
          child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapCancel: () => setState(() => _isPressed = false),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.transparent,
                    transitionDuration: const Duration(milliseconds: 750),
                    reverseTransitionDuration:
                        const Duration(milliseconds: 550),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return categoryDetailCard(
                        item: item ?? GetVendorStockList(),
                        heroTag: heroTag,
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      /// 🌊 SPRING PHYSICS CURVE
                      final curved = CurvedAnimation(
                        parent: animation,
                        curve: const Cubic(0.2, 0.8, 0.2, 1),
                        reverseCurve: Curves.easeIn,
                      );

                      /// 🔥 BACKGROUND BLUR (APPLE STYLE)
                      final blur =
                          Tween<double>(begin: 0, end: 18).animate(curved);

                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, _) {
                          return Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: blur.value,
                                  sigmaY: blur.value,
                                ),
                                child: Container(
                                  color: AppColors.black
                                      .withValues(alpha: .08 * animation.value),
                                ),
                              ),
                              FadeTransition(
                                opacity: curved,
                                child: ScaleTransition(
                                  scale: Tween(begin: .94, end: 1.0)
                                      .animate(curved),
                                  child: child,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
              child: AnimatedScale(
                duration: const Duration(milliseconds: 140),
                scale: _isPressed ? .97 : 1,
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),

                    /// 🚀 ULTRA DYNAMIC SHADOW SYSTEM
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: _isPressed ? .12 : .18),
                        blurRadius: _isPressed ? 14 : 26,
                        spreadRadius: -6,
                        offset: Offset(0, _isPressed ? 6 : 14),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: _isPressed ? 6 : 14,
                        spreadRadius: -8,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: .7),
                        blurRadius: 2,
                        spreadRadius: -2,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                          child: AnimatedScale(
                            scale: _isPressed ? 1.03 : 1,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: SizedBox(
                              height: 130,
                              child: CachedNetworkImage(
                                imageUrl: Uri.encodeFull(
                                  EndPoints.getImage(
                                    item?.commodityName?.replaceAll(" ", "-") ??
                                        "",
                                  ),
                                ),
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const ImageShimmer(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image),
                                httpHeaders: const {"Connection": "keep-alive"},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item?.commodityName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: .2,
                            color: Color(0xff0C3C8C),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Location: ${item?.locations ?? ""}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enquire Now",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey.shade600),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  bool _isPressed = false;

  Widget categoryDetailCard(
      {required GetVendorStockList item, required String heroTag}) {
    return AdaptiveScaffold(
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 14) {
                Navigator.pop(context);
              }
            },
            child: Hero(
              tag: heroTag,
              transitionOnUserGestures: true,
              child: RepaintBoundary(
                child: Material(
                  type: MaterialType.transparency,
                  child: Form(
                    key: _formKey,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentGeometry.centerRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 20),

                              /// IMAGE
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  memCacheWidth: 600,
                                  filterQuality: FilterQuality.low,
                                  imageUrl: Uri.encodeFull(
                                    EndPoints.getImage(
                                      item.commodityName
                                              ?.replaceAll(" ", "-") ??
                                          "",
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => const ImageShimmer(),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),

                              /// TITLE
                              Text(
                                item.commodityName ?? "",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Location: ",
                                      style: TextStyleConstants.medium(
                                        context,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${item.locations}",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Sub Commodity: ",
                                      style: TextStyleConstants.medium(
                                        context,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: item.subCommodityName ?? "",
                                      style: TextStyleConstants.medium(context,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Unit: ",
                                          style: TextStyleConstants.medium(
                                            context,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.quantityUnit ?? "",
                                          style: TextStyleConstants.medium(
                                              context,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Quantity: ",
                                          style: TextStyleConstants.medium(
                                            context,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${item.quantity ?? ""}",
                                          style: TextStyleConstants.medium(
                                              context,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Remarks: ",
                                            style: TextStyleConstants.medium(
                                              context,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: item.remarks ?? "",
                                            style: TextStyleConstants.medium(
                                                context,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              /// 🔥 POST ENQUIRY CARD
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7F7F7),
                                  borderRadius: BorderRadius.circular(18),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Post Enquiry",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    /// INFO ROW

                                    const SizedBox(height: 20),
                                    // CommonTextField(
                                    //   titleText: CommonStrings.name,
                                    //   hintText: CommonStrings.enterFullName,
                                    //   titleStyle:
                                    //       TextStyleConstants.semiBold(context),
                                    //   textRequired: CommonStrings.enterFullName,
                                    //   controller: TextEditingController(),
                                    //   textInputType: TextInputType.text,
                                    //   isEnable: true,
                                    //   backgroundColor: AppColors.transparent,
                                    //   autovalidateMode: AutovalidateMode.disabled,
                                    //   validator: (String? value) {
                                    //     if (value == null || value.trim().isEmpty) {
                                    //       return "Required";
                                    //     }

                                    //     return null;
                                    //   },
                                    // ),
                                    // CommonDropdown<CountryCodeList>(
                                    //   label: 'Country *',
                                    //   hint: 'Select Country',
                                    //   dropdownKey: unitKey,
                                    //   asyncItems: (filter, loadProps) {
                                    //     return fetchCountryCode(filter, loadProps);
                                    //   },
                                    //   selectedItem: null,
                                    //   itemAsString: (item) =>
                                    //       "+${item.countryCode ?? ""} - ${item.countryName ?? ""}",
                                    //   onChanged: (item) {
                                    //     selectedCountryCode = item;
                                    //   },
                                    //   validator: (value) {
                                    //     if (value == null) {
                                    //       return "Required";
                                    //     }

                                    //     return null;
                                    //   },
                                    //   compareFn: (a, b) =>
                                    //       a.countryName == b.countryName,
                                    // ),
                                    // CommonTextField(
                                    //   titleText: CommonStrings.mobileNumber,
                                    //   hintText: CommonStrings.enterMobileNumber,
                                    //   titleStyle:
                                    //       TextStyleConstants.semiBold(context),
                                    //   textRequired: CommonStrings.enterMobileNumber,
                                    //   controller: TextEditingController(),
                                    //   textInputType: TextInputType.text,
                                    //   isEnable: true,
                                    //   backgroundColor: AppColors.transparent,
                                    //   autovalidateMode: AutovalidateMode.disabled,
                                    //   validator: (String? value) {
                                    //     if (value == null || value.trim().isEmpty) {
                                    //       return "Required";
                                    //     }

                                    //     return null;
                                    //   },
                                    // ),
                                    // CommonTextField(
                                    //   titleText: CommonStrings.emailId,
                                    //   hintText: CommonStrings.enterEmail,
                                    //   titleStyle:
                                    //       TextStyleConstants.semiBold(context),
                                    //   textRequired: CommonStrings.enterEmail,
                                    //   controller: TextEditingController(),
                                    //   textInputType: TextInputType.text,
                                    //   isEnable: true,
                                    //   backgroundColor: AppColors.transparent,
                                    //   autovalidateMode: AutovalidateMode.disabled,
                                    //   validator: (String? value) {
                                    //     if (value == null || value.trim().isEmpty) {
                                    //       return "Required";
                                    //     }

                                    //     return null;
                                    //   },
                                    // ),
                                    CommonDropdown<AuctionUnitList>(
                                      label: '  Unit *',
                                      hint: 'Select Unit',
                                      dropdownKey: unitKey,
                                      asyncItems: (filter, loadProps) {
                                        return fetchItemUnit(filter, loadProps);
                                      },
                                      selectedItem: null,
                                      itemAsString: (item) =>
                                          item.unitName ?? "",
                                      onChanged: (item) {
                                        selectedUnit = item;
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Required";
                                        }

                                        return null;
                                      },
                                      compareFn: (a, b) =>
                                          a.unitName == b.unitName,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    CommonTextField(
                                      titleText: CommonStrings.quantity,
                                      titleStyle:
                                          TextStyleConstants.semiBold(context),
                                      hintText: CommonStrings.enterQuantity,
                                      textRequired: CommonStrings.enterQuantity,
                                      controller: quantityController,
                                      backgroundColor: AppColors.transparent,
                                      textInputType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      isEnable: true,
                                      height: 45,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String? value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Required";
                                        }

                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),

                                    CommonTextField(
                                      titleText: CommonStrings.message,
                                      hintText: CommonStrings.enterMessage,
                                      titleStyle:
                                          TextStyleConstants.semiBold(context),
                                      textRequired: CommonStrings.enterMessage,
                                      controller: remarksController,
                                      textInputType: TextInputType.text,
                                      isEnable: true,
                                      backgroundColor: AppColors.transparent,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      validator: (String? value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Required";
                                        }

                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    /// SUBMIT BUTTON
                                    SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: CommonButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            var params =
                                                AddVendorStockEnquiryParams(
                                              token: await secureStorage.read(
                                                      AppStrings
                                                          .apiVerificationCode) ??
                                                  "",
                                              requirementID:
                                                  item.requirementId.toString(),
                                              buyerID: await secureStorage.read(
                                                      AppStrings.customerId) ??
                                                  "",
                                              name: '',
                                              email: '',
                                              quantity: quantityController.text,
                                              countryID: "0",
                                              mobileNo: '',
                                              unit:
                                                  selectedUnit?.unitName ?? '',
                                              remarks: remarksController.text,
                                              insertedID: await secureStorage
                                                      .read(AppStrings
                                                          .customerId) ??
                                                  "",
                                            );

                                            await dashboardCubit
                                                .addVendorStockEnquiry(params);
                                          }
                                        },
                                        text: "Submit",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is AddVendorStockEnquiryIsLoading) {
                return const CommonLoader();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
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

class ImageShimmer extends StatelessWidget {
  final double radius;

  const ImageShimmer({super.key, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
