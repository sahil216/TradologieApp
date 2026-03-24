// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';

import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/get_device_id.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/routes/navigation_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _gifReady = false;

  // Animation controller for the logo fade + slide in
  late final AnimationController _logoController;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoSlide;

  @override
  void initState() {
    super.initState();

    // Logo animates in: fades + slides up from slightly below
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _initDevice(),
        _preloadGif(),
      ]);
    });
  }

  Future<void> _initDevice() async {
    Constants().checkAndroidVersion();
    if (Constants.deviceID == "") {
      Constants.deviceID = await DeviceIdService.getDeviceId();
    }
  }

  /// Decodes the GIF into Flutter's image cache so that
  /// Image.asset renders on the very first frame — no white flash.
  Future<void> _preloadGif() async {
    await precacheImage(
      const AssetImage("assets/images/splash.gif"),
      context,
    );

    if (!mounted) return;
    setState(() => _gifReady = true);

    // Start logo animation shortly after GIF appears
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _logoController.forward();
    });

    // Navigate after GIF finishes — adjust to match your GIF duration
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      _goNext(context);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<void> nameUpdate() async {
    final SecureStorageService secureStorage = SecureStorageService();
    Constants.name = Constants.isFmcg == true
        ? await secureStorage.read(AppStrings.fmcgName) ?? ""
        : Constants.isBuyer == true
            ? await secureStorage.read(AppStrings.customerName) ?? ""
            : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  Future<void> _goNext(BuildContext context) async {
    nameUpdate();
    if (Constants.isLogin) {
      if (Constants.isFmcg == true) {
        sl<NavigationService>().pushNamedAndRemoveUntil(Routes.fmcgMainScreen);
      } else {
        sl<NavigationService>().pushNamedAndRemoveUntil(Routes.mainRoute);
      }
    } else {
      sl<NavigationService>().pushNamedAndRemoveUntil(Routes.onboardingRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AdaptiveScaffold(
      body: SafeArea(
        child: BlocListener<AppCubit, AppState>(
          listener: (context, state) {},
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              BlocBuilder<AppCubit, AppState>(
                buildWhen: (previous, current) {
                  bool result = current != previous;
                  result = result &&
                      (current is CheckForceUpdateError ||
                          current is CheckForceUpdateIsLoading ||
                          current is CheckForceUpdateSuccess);
                  return result;
                },
                builder: (context, state) => const SizedBox.shrink(),
              ),

              // ── Main content column ──────────────────────────────────────
              SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GIF animation
                    SizedBox(
                      height: screenHeight * 0.55,
                      width: screenWidth,
                      child: _gifReady
                          // ✅ GIF fully cached — renders instantly, no flash
                          ? Image.asset(
                              "assets/images/splash.gif",
                              fit: BoxFit.contain,
                              gaplessPlayback: true,
                            )
                          // ✅ Fixed-height placeholder — no infinite constraint
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),

                    // Logo — fades + slides up into view
                    SlideTransition(
                      position: _logoSlide,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Image.asset(
                                ImgAssets.companyLogo, // your logo asset path
                                height: screenHeight * 0.1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom URL text ──────────────────────────────────────────
              Positioned(
                bottom: 1,
                child: CommonText(
                  CommonStrings.tradologieWebsitewithouthttp,
                  textAlign: TextAlign.center,
                  style: TextStyleConstants.regular(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
