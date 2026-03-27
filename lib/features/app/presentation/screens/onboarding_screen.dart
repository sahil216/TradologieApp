import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';

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
    Constants.name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
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
              child: SizedBox(
                height: 60,
              ),
            ),
            SliverToBoxAdapter(
              child: Image.asset(ImgAssets.companyLogo, height: 60),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: Responsive(context).screenHeight * 0.2,
                child: Lottie.asset("assets/images/splash_screen.json"),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Choose Business Category",
                  textAlign: TextAlign.center,
                  style: TextStyleConstants.semiBold(
                    context,
                    color: AppColors.defaultText,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    BusinessCard(
                      title: "Seller-Agro Commodity",
                      subtitle: "List & Sell Agro Commodities",
                      image: "assets/images/agro_image.png",
                      onTap: () async {
                        SecureStorageService secureStorage =
                            SecureStorageService();
                        Constants.isBuyer = false;
                        Constants.isFmcg = false;
                        await secureStorage.write(AppStrings.isBuyer, "false");
                        await secureStorage.write(AppStrings.isFmcg, "false");
                        sl<NavigationService>().pushNamed(Routes.signinRoute);
                        AnalyticsService.logEvent("seller_button_clicked");
                      },
                    ),
                    BusinessCard(
                      title: "Buyer-Agro Commodity",
                      subtitle: "Negotiate and Purchase Agro Commodities",
                      image: "assets/images/agro_image.png",
                      onTap: () async {
                        SecureStorageService secureStorage =
                            SecureStorageService();
                        Constants.isBuyer = true;
                        Constants.isFmcg = false;
                        await secureStorage.write(AppStrings.isBuyer, "true");
                        await secureStorage.write(AppStrings.isFmcg, "false");
                        sl<NavigationService>().pushNamed(Routes.signinRoute);
                        AnalyticsService.logEvent("buyer_button_clicked");
                      },
                    ),
                    BusinessCard(
                      title: "Seller- FMCG & Packaged Food",
                      subtitle: "List & Sell Agro Commodities",
                      image: "assets/images/fmcg_image.jpg",
                      onTap: () async {
                        SecureStorageService secureStorage =
                            SecureStorageService();
                        Constants.isBuyer = false;
                        Constants.isFmcg = true;
                        await secureStorage.write(AppStrings.isFmcg, "true");
                        await secureStorage.write(AppStrings.isBuyer, "false");
                        sl<NavigationService>()
                            .pushNamed(Routes.fmcgSignIn, arguments: false);
                        AnalyticsService.logEvent("fmcg_seller_button_clicked");
                      },
                    ),
                    BusinessCard(
                      title: "Buyer- FMCG & Packaged Food",
                      subtitle: "Negotiate and Purchase Agro Commodities",
                      image: "assets/images/fmcg_image.jpg",
                      onTap: () async {
                        SecureStorageService secureStorage =
                            SecureStorageService();
                        Constants.isBuyer = true;
                        Constants.isFmcg = true;
                        await secureStorage.write(AppStrings.isFmcg, "true");
                        await secureStorage.write(AppStrings.isBuyer, "true");
                        sl<NavigationService>()
                            .pushNamed(Routes.fmcgSignIn, arguments: true);
                        AnalyticsService.logEvent("fmcg_buyer_button_clicked");
                      },
                    ),
                    // BusinessCard(
                    //   title: "E-mandi",
                    //   subtitle: "List & Sell Agro Commodities",
                    //   image: "assets/mandi.png",
                    // ),
                  ],
                ),
              ),
            ),
            // SliverFillRemaining(
            //   hasScrollBody: false,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child: Column(
            //       children: [
            //         CommonDropdown<String>(
            //           label: '',
            //           hint: 'Select Product Type',
            //           dropdownKey: productKey,
            //           asyncItems: (filter, loadProps) {
            //             return selectProductType(filter, loadProps);
            //           },
            //           selectedItem: null,
            //           itemAsString: (item) => item,
            //           onChanged: (item) {
            //             selectedProduct = item;
            //             setState(() {});
            //           },
            //           compareFn: (a, b) => a == b,
            //         ),
            //         SizedBox(height: 8),
            //         // selectedProduct == "AgroCommodity"
            //         //     ? CommonDropdown<String>(
            //         //         label: '',
            //         //         hint: 'Select User Type',
            //         //         dropdownKey: userKey,
            //         //         asyncItems: (filter, loadProps) {
            //         //           return selectUserType(
            //         //               filter, loadProps);
            //         //         },
            //         //         selectedItem: null,
            //         //         itemAsString: (item) => item,
            //         //         onChanged: (item) {
            //         //           selectedUserType = item;
            //         //         },
            //         //         compareFn: (a, b) => a == b,
            //         //       )
            //         //     : SizedBox.shrink(),
            //         // SizedBox(height: 12),

            //         // Column(
            //         //   children: [
            //         // SizedBox(height: 30),
            //         // Text(
            //         //   "Choose Role to Continue.",
            //         //   textAlign: TextAlign.center,
            //         //   style: TextStyleConstants.regular(
            //         //     context,
            //         //     color: AppColors.defaultText,
            //         //     fontSize: 16,
            //         //   ),
            //         // ),
            //         SizedBox(height: 20),
            //         selectedProduct == null
            //             ? SizedBox()
            //             : CommonButton(
            //                 onPressed: selectedProduct == "Agro Commodity"
            //                     ? () async {
            //                         SecureStorageService secureStorage =
            //                             SecureStorageService();
            //                         Constants.isBuyer = false;
            //                         Constants.isFmcg = false;
            //                         await secureStorage.write(
            //                             AppStrings.isBuyer, "false");
            //                         await secureStorage.write(
            //                             AppStrings.isFmcg, "false");
            //                         sl<NavigationService>()
            //                             .pushNamed(Routes.sendOtpScreen);
            //                         AnalyticsService.logEvent(
            //                             "seller_button_clicked");
            //                       }
            //                     : () async {
            //                         SecureStorageService secureStorage =
            //                             SecureStorageService();
            //                         Constants.isBuyer = false;
            //                         Constants.isFmcg = true;
            //                         await secureStorage.write(
            //                             AppStrings.isFmcg, "true");
            //                         await secureStorage.write(
            //                             AppStrings.isBuyer, "false");
            //                         sl<NavigationService>().pushNamed(
            //                             Routes.fmcgSignIn,
            //                             arguments: false);
            //                       },
            //                 text: selectedProduct == "Agro Commodity"
            //                     ? CommonStrings.sellerText
            //                     : "Register Your Brand",
            //                 width: double.infinity,
            //                 borderRadius: BorderRadius.circular(8),
            //                 backgroundColor: AppColors.primary,
            //                 padding: EdgeInsets.zero,
            //                 textStyle: TextStyleConstants.medium(
            //                   context,
            //                   color: AppColors.white,
            //                   fontSize: 16,
            //                 ),
            //               ),
            //         //   ],
            //         // ),
            //         SizedBox(height: 16),

            //         selectedProduct == null
            //             ? SizedBox()
            //             : CommonButton(
            //                 onPressed: selectedProduct == "Agro Commodity"
            //                     ? () async {
            //                         SecureStorageService secureStorage =
            //                             SecureStorageService();
            //                         Constants.isBuyer = true;
            //                         Constants.isFmcg = false;
            //                         await secureStorage.write(
            //                             AppStrings.isBuyer, "true");
            //                         await secureStorage.write(
            //                             AppStrings.isFmcg, "false");
            //                         sl<NavigationService>()
            //                             .pushNamed(Routes.sendOtpScreen);
            //                         AnalyticsService.logEvent(
            //                             "buyer_button_clicked");
            //                       }
            //                     : () async {
            //                         SecureStorageService secureStorage =
            //                             SecureStorageService();
            //                         Constants.isBuyer = true;
            //                         Constants.isFmcg = true;
            //                         await secureStorage.write(
            //                             AppStrings.isFmcg, "true");
            //                         await secureStorage.write(
            //                             AppStrings.isBuyer, "true");
            //                         sl<NavigationService>().pushNamed(
            //                             Routes.fmcgSignIn,
            //                             arguments: true);
            //                       },
            //                 text: selectedProduct == "Agro Commodity"
            //                     ? CommonStrings.buyerText
            //                     : "Apply for Distributorship",
            //                 width: double.infinity,
            //                 borderRadius: BorderRadius.circular(8),
            //                 backgroundColor: AppColors.blueLight,
            //                 padding: EdgeInsets.zero,
            //                 textStyle: TextStyleConstants.medium(
            //                   context,
            //                   color: AppColors.blueDark,
            //                   fontSize: 16,
            //                 ),
            //               ),

            //         Spacer(),
            //         Text(
            //           CommonStrings.bottomInfoBeAssured,
            //           textAlign: TextAlign.center,
            //           style: TextStyleConstants.regular(
            //             context,
            //             color: AppColors.defaultText,
            //             fontSize: 14,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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

class BusinessCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback? onTap;

  const BusinessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
  });

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: isPressed ? 0.96 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),

          /// 🌈 Outer subtle glow border
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                ),
              ]
              // gradient: LinearGradient(
              //   colors: [
              //     Colors.white.withValues(alpha: 0.6),
              //     Colors.white.withValues(alpha: 0.1),
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              ),

          child: Padding(
            padding: const EdgeInsets.all(1.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),

                    /// ✨ Main glass surface
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    /// 💡 Light edge + soft shadow
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),

                    // boxShadow: [
                    //   /// outer soft shadow
                    //   BoxShadow(
                    //     color: Colors.black.withValues(alpha: 0.08),
                    //     blurRadius: 20,
                    //     offset: const Offset(0, 10),
                    //   ),

                    //   /// inner light glow illusion
                    //   BoxShadow(
                    //     color: Colors.white.withValues(alpha: 0.6),
                    //     blurRadius: 10,
                    //     spreadRadius: -4,
                    //     offset: const Offset(-2, -2),
                    //   ),
                    // ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTap,
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        child: Row(
                          children: [
                            /// 🔵 Avatar (glass circle)
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(widget.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            /// 🔹 Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF1B3C59),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.subtitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// ➡ Arrow
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade600,
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
      ),
    );
  }
}
