import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/app/presentation/widgets/animated_rotating_image.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  List<String> productCategoryList = ["Agro Commodity", "FMCG & Packaged Food"];
  List<String> userTypeList = ["Buyer", "Seller"];
  Key productKey = UniqueKey();
  Key userKey = UniqueKey();

  String? selectedProduct;
  String? selectedUserType;

  TradeType? selectedTradeType;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
      nameUpdate();
    });
  }

  List<String> selectProductType(String filter, LoadProps? loadProps) {
    final allItems = productCategoryList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => e.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<String> selectUserType(String filter, LoadProps? loadProps) {
    final allItems = userTypeList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => e.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<void> nameUpdate() async {
    SecureStorageService secureStorage = SecureStorageService();
    Constants.name = Constants.isBuyer == true
        ? await secureStorage.read(AppStrings.customerName) ?? ""
        : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      // appBar: Constants.appBar(context, height: 0, boxShadow: []),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Image.asset(
                ImgAssets.onboardingImage,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CircularImageRotator(),
                    SizedBox(height: 15),
                    Text(CommonStrings.getStarted.toUpperCase(),
                        style: TextStyleConstants.medium(
                          context,
                          color: AppColors.defaultText,
                          fontSize: 30,
                        )),
                    SizedBox(height: 8),
                    CommonDropdown<String>(
                      label: '',
                      hint: 'Select Product Type',
                      dropdownKey: productKey,
                      asyncItems: (filter, loadProps) {
                        return selectProductType(filter, loadProps);
                      },
                      selectedItem: null,
                      itemAsString: (item) => item,
                      onChanged: (item) {
                        selectedProduct = item;
                        setState(() {});
                      },
                      compareFn: (a, b) => a == b,
                    ),
                    SizedBox(height: 8),
                    // selectedProduct == "AgroCommodity"
                    //     ? CommonDropdown<String>(
                    //         label: '',
                    //         hint: 'Select User Type',
                    //         dropdownKey: userKey,
                    //         asyncItems: (filter, loadProps) {
                    //           return selectUserType(
                    //               filter, loadProps);
                    //         },
                    //         selectedItem: null,
                    //         itemAsString: (item) => item,
                    //         onChanged: (item) {
                    //           selectedUserType = item;
                    //         },
                    //         compareFn: (a, b) => a == b,
                    //       )
                    //     : SizedBox.shrink(),
                    // SizedBox(height: 12),

                    // Column(
                    //   children: [
                    // SizedBox(height: 30),
                    // Text(
                    //   "Choose Role to Continue.",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyleConstants.regular(
                    //     context,
                    //     color: AppColors.defaultText,
                    //     fontSize: 16,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    selectedProduct == null
                        ? SizedBox()
                        : CommonButton(
                            onPressed: selectedProduct == "Agro Commodity"
                                ? () async {
                                    SecureStorageService secureStorage =
                                        SecureStorageService();
                                    Constants.isBuyer = false;
                                    await secureStorage.write(
                                        AppStrings.isBuyer, "false");
                                    await secureStorage.write(
                                        AppStrings.isFmcg, "false");
                                    sl<NavigationService>()
                                        .pushNamed(Routes.sendOtpScreen);
                                    AnalyticsService.logEvent(
                                        "seller_button_clicked");
                                  }
                                : () async {
                                    SecureStorageService secureStorage =
                                        SecureStorageService();
                                    Constants.isBuyer = false;
                                    await secureStorage.write(
                                        AppStrings.isFmcg, "true");
                                    await secureStorage.write(
                                        AppStrings.isBuyer, "false");
                                    sl<NavigationService>()
                                        .pushNamed(Routes.fmcgSignIn);
                                  },
                            text: selectedProduct == "Agro Commodity"
                                ? CommonStrings.sellerText
                                : "Register Your Brand",
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.zero,
                            textStyle: TextStyleConstants.medium(
                              context,
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                    //   ],
                    // ),
                    SizedBox(height: 16),

                    selectedProduct == null
                        ? SizedBox()
                        : CommonButton(
                            onPressed: selectedProduct == "Agro Commodity"
                                ? () async {
                                    SecureStorageService secureStorage =
                                        SecureStorageService();
                                    Constants.isBuyer = true;
                                    await secureStorage.write(
                                        AppStrings.isBuyer, "true");
                                    await secureStorage.write(
                                        AppStrings.isFmcg, "false");
                                    sl<NavigationService>()
                                        .pushNamed(Routes.sendOtpScreen);
                                    AnalyticsService.logEvent(
                                        "buyer_button_clicked");
                                  }
                                : () async {
                                    sl<NavigationService>().pushNamed(
                                        Routes
                                            .fmcgRegisterSellerDistributorForm,
                                        arguments: true);
                                  },
                            text: selectedProduct == "Agro Commodity"
                                ? CommonStrings.buyerText
                                : "Apply for Distributorship",
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(8),
                            backgroundColor: AppColors.blueLight,
                            padding: EdgeInsets.zero,
                            textStyle: TextStyleConstants.medium(
                              context,
                              color: AppColors.blueDark,
                              fontSize: 16,
                            ),
                          ),

                    Spacer(),
                    Text(
                      CommonStrings.bottomInfoBeAssured,
                      textAlign: TextAlign.center,
                      style: TextStyleConstants.regular(
                        context,
                        color: AppColors.defaultText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum TradeType {
  commodity,
  fmcg,
}
