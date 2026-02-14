import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/sign_in_usecase.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/common_single_child_scroll_view.dart';
import '../../../../core/widgets/common_social_icons.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/authentication_cubit.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
        resizeToAvoidBottomInset: false,
        appBar: Constants.appBar(
          context,
          elevation: 0,
          boxShadow: [],
          centerTitle: true,
          titleWidget: Image.asset(
            ImgAssets.companyLogo,
            height: 40,
          ),
        ),
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is SigninSuccess) {
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
            if (state is BuyerSigninSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.mainRoute,
                (route) => false,
              );
            }
          },
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: ValueListenableBuilder(
                        valueListenable: showPassword,
                        builder: (context, value, child) {
                          return CommonSingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          CommonText(
                                            CommonStrings.signIn,
                                            textAlign: TextAlign.center,
                                            style: TextStyleConstants.medium(
                                              context,
                                              fontSize: 28,
                                              color: AppColors.defaultText,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          CommonTextField(
                                            titleText: CommonStrings.emailId,
                                            hintText: CommonStrings.enterEmail,
                                            controller: textEmailController,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
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
                                          SizedBox(height: 12),
                                          CommonTextField(
                                            titleText: CommonStrings.password,
                                            hintText:
                                                CommonStrings.enterPassword,
                                            controller: textPasswordController,
                                            isObsecureText: showPassword.value
                                                ? false
                                                : true,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                showPassword.value
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: AppColors.grayText,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  showPassword.value =
                                                      !showPassword.value;
                                                });
                                              },
                                            ),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (String? val) {
                                              if (val == null || val.isEmpty) {
                                                return "Password is required";
                                              }

                                              return null;
                                            },
                                          ),
                                          // SizedBox(height: 12),
                                          // Align(
                                          //   alignment: Alignment.centerRight,
                                          //   child: GestureDetector(
                                          //     onTap: () {},
                                          //     child: Text(
                                          //       CommonStrings.forgotPassword,
                                          //       style: TextStyleConstants.regular(
                                          //         context,
                                          //         fontSize: 14,
                                          //         decoration:
                                          //             TextDecoration.underline,
                                          //         color: AppColors.orange,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBox(height: 20),
                                          CommonButton(
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
                                                      textPasswordController
                                                          .text,
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

                                                FocusManager
                                                    .instance.primaryFocus
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
                                            textStyle:
                                                TextStyleConstants.medium(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Center(
                                            child: CommonText(
                                              "OR",
                                              style: TextStyleConstants.regular(
                                                context,
                                                fontSize: 16,
                                                color: AppColors.defaultText,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          SizedBox(
                                            width: r.isTablet
                                                ? 420
                                                : double.infinity,
                                            child: CommonButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              text: CommonStrings
                                                  .sendOtpViaWhatsapp,
                                              backgroundColor: AppColors.white,
                                              borderSide: BorderSide(
                                                color: AppColors
                                                    .green, // or any color you want
                                                width: 2,
                                              ),
                                              icon: Image.asset(
                                                  ImgAssets.whatsappIcon),
                                              textStyle:
                                                  TextStyleConstants.medium(
                                                context,
                                                fontSize: 16,
                                                color: AppColors.black,
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
                          );
                        }),
                  );
                },
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is SigninIsLoading) {
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
