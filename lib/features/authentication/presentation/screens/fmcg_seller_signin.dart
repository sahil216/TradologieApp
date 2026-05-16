import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/responsive.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_seller_signin_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/supplier_social_login_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/fmcg_login_navigation.dart';
import 'package:tradologie_app/injection_container.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/common_social_icons.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/authentication_cubit.dart';

class FmcgSellerSignin extends StatefulWidget {
  final bool isBuyer;

  const FmcgSellerSignin({super.key, required this.isBuyer});

  @override
  State<FmcgSellerSignin> createState() => _FmcgSellerSigninState();
}

class _FmcgSellerSigninState extends State<FmcgSellerSignin>
    with SingleTickerProviderStateMixin {
  final textEmailController = TextEditingController();
  final textPasswordController = TextEditingController();

  SecureStorageService secureStorageService = SecureStorageService();

  bool isSubmitted = false;

  String model = '';
  String osVersionRelease = '';
  String deviceId = '';
  String manufacturer = '';
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  final deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> initPlatformState() async {
    try {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _readAndroidBuildData(
            await deviceInfoPlugin.androidInfo,
          );
          break;

        case TargetPlatform.iOS:
          _readIosDeviceInfo(
            await deviceInfoPlugin.iosInfo,
          );
          break;

        default:
          throw UnimplementedError(
            'Platform not supported',
          );
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to get device info: $e');
    }

    if (!mounted) return;
    setState(() {});
  }

  void _readAndroidBuildData(AndroidDeviceInfo build) {
    manufacturer = build.manufacturer;
    model = build.model;
    osVersionRelease = build.version.release;
    deviceId = build.id;
  }

  void _readIosDeviceInfo(IosDeviceInfo data) {
    manufacturer = "Apple";
    model = data.modelName;
    osVersionRelease = data.systemVersion;
    deviceId = data.identifierForVendor ?? "";
  }

  final showPassword = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  Future<void> _signInWithGoogle() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      final google = GoogleSignIn.instance;
      await google.initialize();
      final GoogleSignInAccount googleUser = await google.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      final firebaseUser = FirebaseAuth.instance.currentUser;
      final idToken = await firebaseUser?.getIdToken();
      final email = firebaseUser?.email ?? googleUser.email;
      final displayName =
          firebaseUser?.displayName ?? googleUser.displayName ?? '';
      if (idToken == null || idToken.isEmpty || email.trim().isEmpty) {
        CommonToast.error('Google sign-in failed');
        return;
      }
      final fcmToken =
          await secureStorageService.read(AppStrings.fcmToken) ?? '';
      if (!mounted) return;

      final params = SupplierSocialLoginParams(
        token: '2018APR031848',
        userId: email,
        name: displayName,
        socialMedia: 'Google',
        manufacturer: manufacturer,
        model: model,
        osVersionRelease: osVersionRelease,
        appVersion: appVersion,
        fcmToken: fcmToken.isNotEmpty ? fcmToken : idToken,
        osType: Platform.isAndroid ? 'Android' : 'iOS',
        deviceId: deviceId,
      );

      final cubit = context.read<AuthenticationCubit>();
      if (widget.isBuyer) {
        cubit.fmcgBuyerSocialSignIn(params);
      } else {
        cubit.fmcgSellerSocialSignIn(params);
      }
    } catch (_) {
      if (!mounted) return;
      CommonToast.error('Google sign-in failed');
    }
  }

  @override
  void dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is FmcgSellerSigninSuccess) {
              Constants.isFmcg = true;
              Constants.isBuyer = widget.isBuyer;
              secureStorageService.write(AppStrings.isFmcg, "true");
              secureStorageService.write(
                  AppStrings.isBuyer, widget.isBuyer.toString());
              if (state.data.fmcgUserDetail?.fromDate != "-" &&
                  state.data.fmcgUserDetail?.toDate != "-") {
                Constants().hideSensitiveData = Constants().isTodayInRange(
                    DateTime.parse(state.data.fmcgUserDetail?.fromDate ?? ""),
                    DateTime.parse(state.data.fmcgUserDetail?.toDate ?? ""));
              } else {
                Constants().hideSensitiveData = true;
              }
              navigateToFmcgMainAfterLogin(context);
            }
            if (state is FmcgSellerSigninError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is FmcgBuyerSigninSuccess) {
              Constants.isFmcg = true;
              Constants.isBuyer = widget.isBuyer;
              secureStorageService.write(AppStrings.isFmcg, "true");
              secureStorageService.write(
                  AppStrings.isBuyer, widget.isBuyer.toString());
              navigateToFmcgMainAfterLogin(context);
            }
            if (state is FmcgBuyerSigninError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              ValueListenableBuilder(
                  valueListenable: showPassword,
                  builder: (context, value, child) {
                    return CustomScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        CommonAppbar(
                          title: CommonStrings.signIn,
                          showBackButton: true,
                          showNotification: false,
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CommonTextField(
                                        titleText: CommonStrings.emailId,
                                        hintText: CommonStrings.enterEmail,
                                        controller: textEmailController,
                                        textInputType:
                                            TextInputType.emailAddress,
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
                                      SizedBox(height: 12),
                                      CommonTextField(
                                        titleText: CommonStrings.password,
                                        hintText: CommonStrings.enterPassword,
                                        controller: textPasswordController,
                                        isObsecureText:
                                            showPassword.value ? false : true,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            showPassword.value
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: AppColors.grayText,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPassword.value =
                                                  !showPassword.value;
                                            });
                                          },
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (String? val) {
                                          if (val == null || val.isEmpty) {
                                            return "Password is required";
                                          }

                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      CommonButton(
                                        onPressed: () async {
                                          late FmcgSellerSigninParams params;
                                          if (textEmailController
                                                  .text.isNotEmpty &&
                                              textPasswordController
                                                  .text.isNotEmpty) {
                                            params = FmcgSellerSigninParams(
                                              userId: textEmailController.text,
                                              password:
                                                  textPasswordController.text,
                                              token: "2018APR031848",
                                              osType: Platform.isAndroid
                                                  ? "Android"
                                                  : "iOS",
                                              fcmToken:
                                                  await secureStorageService
                                                          .read(AppStrings
                                                              .fcmToken) ??
                                                      "",
                                              manufacturer: manufacturer,
                                              model: model,
                                              osVersionRelease:
                                                  osVersionRelease,
                                              appVersion: appVersion,
                                              deviceId: deviceId,
                                            );
                                            if (!context.mounted) {
                                              return;
                                            }
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();

                                            widget.isBuyer
                                                ? BlocProvider.of<
                                                            AuthenticationCubit>(
                                                        context)
                                                    .fmcgBuyerSignin(params)
                                                : BlocProvider.of<
                                                            AuthenticationCubit>(
                                                        context)
                                                    .fmcgSellerSignin(params);
                                          }
                                        },
                                        text: CommonStrings.login,
                                        textStyle: TextStyleConstants.medium(
                                          context,
                                          fontSize: 16,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      if (Platform.isAndroid) ...[
                                        SizedBox(height: 20),
                                        Center(
                                          child: CommonText(
                                            'OR',
                                            style: TextStyleConstants.regular(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.defaultText,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        SizedBox(
                                          width:
                                              r.isTablet ? 420 : double.infinity,
                                          child: CommonButton(
                                            onPressed: _signInWithGoogle,
                                            text: 'Continue with Gmail',
                                            backgroundColor: AppColors.white,
                                            borderSide: BorderSide(
                                              color: AppColors.red,
                                              width: 2,
                                            ),
                                            icon: Image.asset(ImgAssets.google),
                                            textStyle:
                                                TextStyleConstants.medium(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 20),
                                      SizedBox(
                                        width:
                                            r.isTablet ? 420 : double.infinity,
                                        child: CommonButton(
                                          onPressed: () {
                                            //  Navigator.pop(context);

                                            // code by Gopal

                                            sl<NavigationService>().pushNamed(
                                                Routes.sendOtpScreen);
                                          },
                                          text: Constants.isFmcg &&
                                                  Constants.isBuyer
                                              ? CommonStrings.loginViaWhatsapp
                                              : CommonStrings
                                                  .sendOtpViaWhatsapp,
                                          backgroundColor: AppColors.white,
                                          borderSide: BorderSide(
                                            color: AppColors
                                                .green, // or any color you want
                                            width: 2,
                                          ),
                                          icon: Image.asset(
                                              ImgAssets.whatsappIcon),
                                          textStyle: TextStyleConstants.medium(
                                            context,
                                            fontSize: 16,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      InkWell(
                                        onTap: widget.isBuyer == true
                                            ? () {
                                          sl<NavigationService>().pushNamed(
                                              Routes
                                                  .fmcgRegisterSellerDistributorForm,
                                              arguments: true);
                                        }
                                            : () {
                                          sl<NavigationService>().pushNamed(
                                              Routes
                                                  .fmcgRegisterSellerDistributorForm,
                                              arguments: false);
                                        },
                                        child: Center(
                                          child: Constants.isBuyer == true
                                              ? RichText(
                                            text: TextSpan(
                                              text:
                                              "Don't have an account? ",
                                              style: TextStyleConstants
                                                  .regular(
                                                context,
                                                fontSize: 16,
                                                color:
                                                AppColors.defaultText,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "Register Now",
                                                  style:
                                                  TextStyleConstants
                                                      .semiBold(
                                                    context,
                                                    fontSize: 16,
                                                    color: AppColors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              : CommonText(
                                            "Register New Brand",
                                            style: TextStyleConstants
                                                .semiBold(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CommonSocialIcons(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is FmcgSellerSigninIsLoading ||
                      state is FmcgBuyerSigninIsLoading) {
                    return Positioned.fill(child: const CommonLoader());
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
