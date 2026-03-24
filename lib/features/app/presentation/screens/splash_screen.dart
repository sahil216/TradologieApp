// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Constants().checkAndroidVersion();
      if (Constants.deviceID == "") {
        Constants.deviceID = await DeviceIdService.getDeviceId();
      }
    });

    startDelay(context);
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<void> nameUpdate() async {
    SecureStorageService secureStorage = SecureStorageService();
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
        if (Constants.isBuyer == true) {
          sl<NavigationService>()
              .pushNamedAndRemoveUntil(Routes.fmcgMainScreen);
        } else {
          sl<NavigationService>()
              .pushNamedAndRemoveUntil(Routes.fmcgMainScreen);
        }
      } else {
        if (Constants.isBuyer == true) {
          sl<NavigationService>().pushNamedAndRemoveUntil(Routes.mainRoute);
        } else {
          sl<NavigationService>().pushNamedAndRemoveUntil(Routes.mainRoute);
        }
      }
    } else {
      sl<NavigationService>().pushNamedAndRemoveUntil(Routes.onboardingRoute);
    }
  }

  void startDelay(BuildContext context) {
    Future.delayed(const Duration(seconds: 10), () {
      if (!context.mounted) return;
      _goNext(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // startDelay(context);
    return AdaptiveScaffold(
      // appBar: Constants.appBar(context, height: 0, boxShadow: []),
      body: SafeArea(
        child: BlocListener<AppCubit, AppState>(
          listener: (context, state) {
            // _goNext(context); // ✅ Navigate only if app is allowed
          },
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
                builder: (context, state) {
                  return const SizedBox.shrink();
                },
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Lottie.asset(
                        "assets/images/splash_screen.json",
                        fit: BoxFit.contain,
                        frameRate: FrameRate.max,
                        repeat: false,
                        onLoaded: (composition) {
                          Future.delayed(composition.duration, () {
                            _goNext(context);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 1,
                child: CommonText(
                  CommonStrings.tradologieWebsitewithouthttp,
                  textAlign: TextAlign.center,
                  style: TextStyleConstants.regular(
                    context,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
