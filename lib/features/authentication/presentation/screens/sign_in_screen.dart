import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/analytics_services.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/supplier_social_login_usecase.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../injection_container.dart';
import 'package:tradologie_app/features/fmcg/presentation/fmcg_login_navigation.dart';

import '../cubit/authentication_cubit.dart';
import '../widget/login_video_section.dart';
import 'package:tradologie_app/core/utils/login_video_constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  /// Set to `true` when you want the Facebook login button visible.
  static const bool showFacebookLogin = false;

  /// Gmail / Google sign-in on Android and iOS.
  static bool get showGmailLogin =>
      Platform.isAndroid || Platform.isIOS;

  @override
  State<SignInScreen> createState() => _SignInScreenState();

}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final textEmailController = TextEditingController();
  final textPasswordController = TextEditingController();

  final deviceInfoPlugin = DeviceInfoPlugin();

  SecureStorageService secureStorageService = SecureStorageService();

  bool isSubmitted = false;

  String model = '';
  String osVersionRelease = '';
  String deviceId = '';
  String manufacturer = '';
  String appVersion = '';
  bool showforgotpassword = false;

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
    if (!Platform.isAndroid && !Platform.isIOS) {
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

      if (Constants.isFmcg) {
        final firebaseUser = FirebaseAuth.instance.currentUser;
        final idToken = await firebaseUser?.getIdToken();
        final email = firebaseUser?.email ?? googleUser.email;
        final displayName =
            firebaseUser?.displayName ?? googleUser.displayName ?? '';
        if (idToken == null || idToken.isEmpty || email.trim().isEmpty) {
          CommonToast.error("Google sign-in failed");
          return;
        }
        final fcmToken =
            await secureStorageService.read(AppStrings.fcmToken) ?? '';
        if (!mounted) return;
        final params = SupplierSocialLoginParams(
          token: "2018APR031848",
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
        final cubit = BlocProvider.of<AuthenticationCubit>(context);
        if (Constants.isBuyer) {
          cubit.fmcgBuyerSocialSignIn(params);
        } else {
          cubit.fmcgSellerSocialSignIn(params);
        }
      } else {
        if (Constants.isBuyer) {
          final firebaseUser = FirebaseAuth.instance.currentUser;
          final idToken = await firebaseUser?.getIdToken();
          final email = firebaseUser?.email ?? googleUser.email;
          final displayName =
              firebaseUser?.displayName ?? googleUser.displayName ?? '';
          if (idToken == null || idToken.isEmpty || email.trim().isEmpty) {
            CommonToast.error("Google sign-in failed");
            return;
          }
          final fcmToken =
              await secureStorageService.read(AppStrings.fcmToken) ?? '';
          if (!mounted) return;

          // CommonToast.normal("id is $displayName");
          BlocProvider.of<AuthenticationCubit>(context).buyerSocialSignIn(
            SupplierSocialLoginParams(
              token: "2018APR031848",
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
            ),
          );
        } else {
          final firebaseUser = FirebaseAuth.instance.currentUser;
          final idToken = await firebaseUser?.getIdToken();
          final email = firebaseUser?.email ?? googleUser.email;
          final displayName =
              firebaseUser?.displayName ?? googleUser.displayName ?? '';
          if (idToken == null || idToken.isEmpty || email.trim().isEmpty) {
            CommonToast.error("Google sign-in failed");
            return;
          }
          final fcmToken =
              await secureStorageService.read(AppStrings.fcmToken) ?? '';
          if (!mounted) return;
          BlocProvider.of<AuthenticationCubit>(context).supplierSocialSignIn(
            SupplierSocialLoginParams(
              token: "2018APR031848",
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
            ),
          );
        }
      }

      /* Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.mainRoute,
        (route) => false,
      );*/
    } catch (e) {
      if (!mounted) return;
      CommonToast.error("Google sign-in failed");
    }
  }

  /// Uses classic Facebook login tracking so Firebase receives a standard OAuth access token.
  Future<void> _signInWithFacebook() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      if (!mounted) return;
      CommonToast.error(
          "Facebook sign-in is only available on Android and iOS");
      return;
    }
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
        loginTracking: LoginTracking.enabled,
      );
      if (result.status == LoginStatus.cancelled) {
        return;
      }
      if (result.status != LoginStatus.success || result.accessToken == null) {
        if (!mounted) return;
        CommonToast.error(result.message ?? "Facebook sign-in failed");
        return;
      }
      final credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.mainRoute,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      CommonToast.error("Facebook sign-in failed");
    }
  }

  @override
  void dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();

    super.dispose();
  }

  Widget _buildSocialLoginSection(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final buttonW = screenW > 520 ? 400.0 : screenW - 32.0;
    final hasGoogle = SignInScreen.showGmailLogin;
    final hasFacebook = SignInScreen.showFacebookLogin;
    final showOrBridge = hasGoogle || hasFacebook;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        if (showOrBridge) ...[
          Row(
            children: [
              Expanded(
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.grayText.withValues(alpha: 0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'or continue with',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grayText,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.grayText.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        if (hasGoogle)
          SizedBox(
            width: buttonW,
            child: CommonButton(
              onPressed: _signInWithGoogle,
              text: 'Continue with Google',
              height: 44,
              backgroundColor: Colors.white,
              borderSide: BorderSide(
                color: AppColors.defaultText.withValues(alpha: 0.12),
                width: 1,
              ),
              elevation: 0,
              radius: 12,
              icon: Image.asset(
                ImgAssets.google,
                width: 20,
                height: 20,
              ),
              textStyle: TextStyleConstants.medium(
                context,
                fontSize: 14,
                color: AppColors.defaultText,
              ),
            ),
          ),
        if (hasGoogle && hasFacebook) const SizedBox(height: 8),
        if (hasFacebook)
          SizedBox(
            width: buttonW,
            child: CommonButton(
              onPressed: _signInWithFacebook,
              text: 'Continue with Facebook',
              height: 44,
              backgroundColor: const Color(0xFF1877F2),
              borderSide: BorderSide.none,
              elevation: 0,
              radius: 12,
              icon: Image.asset(
                ImgAssets.facebook,
                width: 20,
                height: 20,
              ),
              textStyle: TextStyleConstants.medium(
                context,
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        if (hasGoogle || hasFacebook) const SizedBox(height: 8),
        SizedBox(
          width: buttonW,
          child: CommonButton(
            onPressed: () {
              sl<NavigationService>().pushNamed(Routes.sendOtpScreen);
            },
            text: Constants.isFmcg && Constants.isBuyer
                ? CommonStrings.loginViaWhatsapp
                : CommonStrings.sendOtpViaWhatsapp,
            height: 44,
            backgroundColor: AppColors.white,
            borderSide: BorderSide(
              color: AppColors.defaultText.withValues(alpha: 0.12),
              width: 1,
            ),
            elevation: 0,
            radius: 12,
            icon: Image.asset(
              ImgAssets.whatsappIcon,
              width: 20,
              height: 20,
            ),
            textStyle: TextStyleConstants.medium(
              context,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is SigninSuccess) {
              AnalyticsService.logEvent("seller_email_login_success");
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.mainRoute,
                (route) => false,
              );

              // SecureStorageService secureStorage = SecureStorageService();

              // Navigator.pushReplacementNamed(
              //   context,
              //   Routes.webViewRoute,
              //   arguments: Uri.parse(
              //     "${EndPoints.supplierWebsiteurl}Mobile_login.aspx",
              //   ).replace(
              //     queryParameters: {
              //       "USERID": state.data?.userId.toString(),
              //       "VendorNAME": state.data?.vendorName.toString(),
              //       "Password": await secureStorage.read(
              //         AppStrings.password,
              //       ),
              //       "VendorID": state.data?.vendorId.toString(),
              //       "ImageExist": state.data?.imageExist?.toString().toString(),
              //       "SellerTimeZone": state.data?.sellerTimeZone.toString(),
              //       "RegistrationStatus":
              //           state.data?.registrationStatus.toString(),
              //       "Project_Type": "Seller Control Panel",
              //     },
              //   ).toString(),
              // );
            }
            if (state is SigninError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is ForgotPasswordSendOtpSuccess) {
              final message = state.data.message?.trim();
              CommonToast.success(
                message?.isNotEmpty == true
                    ? message!
                    : 'OTP sent successfully',
              );
            }
            if (state is ForgotPasswordSendOtpError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is BuyerSigninSuccess) {
              AnalyticsService.logEvent("buyer_email_login_success");
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.mainRoute,
                (route) => false,
              );
            }
            if (state is FmcgSellerSigninSuccess) {
              Constants.isFmcg = true;
              Constants.isBuyer = false;
              secureStorageService.write(AppStrings.isFmcg, "true");
              secureStorageService.write(AppStrings.isBuyer, "false");
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
              Constants.isBuyer = true;
              secureStorageService.write(AppStrings.isFmcg, "true");
              secureStorageService.write(AppStrings.isBuyer, "true");
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
                          expandedHeight: 64,
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Form(
                                  key: formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 8),
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
                                            return "Email is required";
                                          }
                                          if (value.isEmailValid == false) {
                                            return "Enter a valid email";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 8),
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

                                      if(showforgotpassword)
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.forgotPasswordRoute,
                                          );
                                        },
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                              "Forgot Password",
                                              style: GoogleFonts.dmSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFF16522),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      CommonButton(
                                        height: 46,
                                        onPressed: () async {
                                          late SigninParams params;
                                          if (textEmailController
                                                  .text.isNotEmpty &&
                                              textPasswordController
                                                  .text.isNotEmpty) {
                                            params = SigninParams(
                                              username:
                                                  textEmailController.text,
                                              password:
                                                  textPasswordController.text,
                                              deviceId: deviceId,
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
                                            );
                                            if (!context.mounted) {
                                              return;
                                            }
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();

                                            if (Constants.isBuyer == true) {
                                              BlocProvider.of<
                                                          AuthenticationCubit>(
                                                      context)
                                                  .buyerSignIn(params);
                                            } else {
                                              BlocProvider.of<
                                                          AuthenticationCubit>(
                                                      context)
                                                  .signIn(params);
                                            }
                                          }
                                        },
                                        text: CommonStrings.login,
                                        textStyle: TextStyleConstants.medium(
                                          context,
                                          fontSize: 15,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      _buildSocialLoginSection(context),
                                    ],
                                  ),
                                ),
                                if (!Constants.isBuyer) ...[
                                  const SizedBox(height: 16),
                                  const LoginVideoSection(
                                    heading: 'Benefits for Agro Exporter',
                                    linkType:
                                        LoginVideoConstants.linkTypeAgroSeller,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is SigninIsLoading ||
                      state is FmcgSellerSigninIsLoading ||
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
