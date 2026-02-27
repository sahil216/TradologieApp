import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../widgets/animated_rotating_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic);

    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
      nameUpdate();
    });
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

  Future<void> nameUpdate() async {
    SecureStorageService secureStorage = SecureStorageService();
    Constants.name = Constants.isBuyer == true
        ? await secureStorage.read(AppStrings.customerName) ?? ""
        : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Stack(
        children: [
          /// 🌈 Soft Animated Luxury Gradient Background

          SafeArea(
              child: FadeTransition(
                  opacity: _screenFade,
                  child: SlideTransition(
                      position: _screenSlide,
                      child: ScaleTransition(
                        scale: _screenScale,
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Transform.translate(
                                offset: const Offset(0, -10),
                                child: RepaintBoundary(
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 600),
                                    tween: Tween(begin: 0, end: 1),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, opacity, child) {
                                      return Opacity(
                                        opacity: opacity,
                                        child: child,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      ImgAssets.onboardingImage,
                                      width: Responsive(context).screenWidth,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            /// 💎 Main Section
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      const CircularImageRotator(),
                                      const SizedBox(height: 30),

                                      /// Title
                                      Text(
                                        CommonStrings.getStarted.toUpperCase(),
                                        style: TextStyleConstants.medium(
                                          context,
                                          fontSize: 32,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      /// Subtitle
                                      Text(
                                        CommonStrings.getStartedText,
                                        textAlign: TextAlign.center,
                                        style: TextStyleConstants.medium(
                                          context,
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),

                                      const SizedBox(height: 40),

                                      /// Seller Button
                                      _luxuryButton(
                                        text: CommonStrings.sellerText,
                                        background: AppColors.primary,
                                        textColor: Colors.white,
                                        onTap: () async {
                                          SecureStorageService secureStorage =
                                              SecureStorageService();
                                          Constants.isBuyer = false;
                                          await secureStorage.write(
                                              AppStrings.isBuyer, "false");
                                          sl<NavigationService>()
                                              .pushNamed(Routes.sendOtpScreen);
                                          AnalyticsService.logEvent(
                                              "seller_button_clicked");
                                        },
                                      ),

                                      const SizedBox(height: 16),

                                      /// Buyer Button
                                      _luxuryButton(
                                        text: CommonStrings.buyerText,
                                        background: AppColors.blueLight,
                                        textColor: AppColors.blueDark,
                                        onTap: () async {
                                          SecureStorageService secureStorage =
                                              SecureStorageService();
                                          Constants.isBuyer = true;
                                          await secureStorage.write(
                                              AppStrings.isBuyer, "true");
                                          sl<NavigationService>()
                                              .pushNamed(Routes.sendOtpScreen);
                                          AnalyticsService.logEvent(
                                              "buyer_button_clicked");
                                        },
                                      ),

                                      const Spacer(),

                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Text(
                                          CommonStrings.bottomInfoBeAssured,
                                          textAlign: TextAlign.center,
                                          style: TextStyleConstants.regular(
                                            context,
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )))),
        ],
      ),
    );
  }

  /// 💎 Premium Micro-interaction Button
  Widget _luxuryButton({
    required String text,
    required Color background,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: background.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyleConstants.medium(
            context,
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
