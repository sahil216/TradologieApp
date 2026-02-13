// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';

import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _checkVersion();
    // });
    startDelay(context);
  }

  // Future<void> _checkVersion() async {
  //   final version = await getAppVersion();

  //   context.read<AppCubit>().checkForceUpdate(
  //         ForceUpdateParams(
  //             token: "2018APR031848",
  //             appVersion: version,
  //             isAndroid: Platform.isAndroid ? true : false),
  //       );
  // }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<void> nameUpdate() async {
    SecureStorageService secureStorage = SecureStorageService();
    Constants.name = Constants.isBuyer == true
        ? await secureStorage.read(AppStrings.customerName) ?? ""
        : await secureStorage.read(AppStrings.vendorName) ?? "";
  }

  Future<void> _goNext(BuildContext context) async {
    nameUpdate();
    if (Constants.isLogin) {
      if (Constants.isBuyer == true) {
        sl<NavigationService>().pushNamedAndRemoveUntil(Routes.mainRoute);
      } else {
        sl<NavigationService>().pushNamedAndRemoveUntil(Routes.mainRoute);
      }
    } else {
      sl<NavigationService>().pushNamedAndRemoveUntil(Routes.onboardingRoute);
    }
  }

  void startDelay(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3000), () => _goNext(context));
  }

  @override
  Widget build(BuildContext context) {
    // startDelay(context);
    return AdaptiveScaffold(
      appBar: Constants.appBar(context, height: 0, boxShadow: []),
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
              Center(
                child: Image.asset(
                  ImgAssets.companyLogo,
                  height: 386,
                  width: 391,
                ),
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
