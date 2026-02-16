import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
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

class _OnboardingScreenState extends State<OnboardingScreen> {
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

  Future<void> nameUpdate() async {
    SecureStorageService secureStorage = SecureStorageService();
    Constants.name = Constants.isBuyer == true
        ? await secureStorage.read(AppStrings.customerName) ?? ""
        : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: Constants.appBar(context, height: 0, boxShadow: []),
      body: SafeArea(
        child: Column(
          children: [
            SvgPicture.asset(
              ImgAssets.onboardingImage,
              width: Responsive(context).screenWidth,
              fit: BoxFit.cover,
              allowDrawingOutsideViewBox: true,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    CircularImageRotator(),
                    SizedBox(height: 30),
                    Text(CommonStrings.getStarted.toUpperCase(),
                        style: TextStyleConstants.medium(
                          context,
                          color: AppColors.defaultText,
                          fontSize: 30,
                        )),
                    SizedBox(height: 8),
                    Text(
                      CommonStrings.getStartedText,
                      textAlign: TextAlign.center,
                      style: TextStyleConstants.medium(
                        context,
                        color: AppColors.defaultText,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 30),
                    CommonButton(
                      onPressed: () async {
                        SecureStorageService secureStorage =
                            SecureStorageService();
                        Constants.isBuyer = false;
                        await secureStorage.write(AppStrings.isBuyer, "false");
                        sl<NavigationService>().pushNamed(Routes.sendOtpScreen);
                      },
                      text: CommonStrings.sellerText,
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
                    SizedBox(height: 16),
                    CommonButton(
                      onPressed: () async {
                        SecureStorageService secureStorage =
                            SecureStorageService();
                        Constants.isBuyer = true;
                        await secureStorage.write(AppStrings.isBuyer, "true");
                        sl<NavigationService>().pushNamed(Routes.sendOtpScreen);
                      },
                      text: CommonStrings.buyerText,
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
