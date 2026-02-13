import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../cubit/authentication_cubit.dart';

class VerifyOtpScreen extends StatefulWidget {
  final SendOtpParams params;
  const VerifyOtpScreen({super.key, required this.params});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final textCodeController = TextEditingController();

  final deviceInfoPlugin = DeviceInfoPlugin();

  SecureStorageService secureStorageService = SecureStorageService();

  bool isSubmitted = false;

  String model = '';
  String osVersionRelease = '';
  String deviceId = '';
  String manufacturer = '';
  String appVersion = '';

  late int _secondsLeft;
  Timer? _timer;

  bool get _canResend => _secondsLeft == 0;

  int get initialSeconds => 30;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPackageInfo();
    _startTimer();
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  void _startTimer() {
    _secondsLeft = initialSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResendTap() {
    if (!_canResend) return;
    Constants.isBuyer == true
        ? BlocProvider.of<AuthenticationCubit>(context)
            .sendOtpBuyer(widget.params, true)
        : BlocProvider.of<AuthenticationCubit>(context)
            .sendOtp(widget.params, true);

    _startTimer();
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
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
            if (state is VerifyOtpSuccess) {
              if (Constants.isBuyer == true) {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.mainRoute, (route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.mainRoute, (route) => false);
              }

              // Navigator.pushReplacementNamed(
              //   context,
              //   Routes.webViewRoute,
              //   arguments: Uri.parse(
              //     "${EndPoints.supplierWebsiteurl}Mobile_login.aspx",
              //   ).replace(
              //     queryParameters: {
              //       "VendorNAME": state.data.vendorName.toString(),
              //       "VendorID": state.data.vendorId.toString(),
              //       "ImageExist": state.data.imageExist?.toString().toString(),
              //       "SellerTimeZone": state.data.sellerTimeZone.toString(),
              //       "RegistrationStatus":
              //           state.data.registrationStatus.toString(),
              //       "Project_Type": "Seller Control Panel",
              //     },
              //   ).toString(),
              // );
            }
            if (state is VerifyOtpError) {
              Constants.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen: (previous, current) {
                  bool result = current != previous;

                  result = result &&
                      (current is VerifyOtpIsLoading ||
                          current is VerifyOtpError ||
                          current is VerifyOtpSuccess);

                  return result;
                },
                builder: (context, state) {
                  if (state is VerifyOtpIsLoading) {
                    return const CommonLoader();
                  }
                  return const SizedBox.shrink();
                },
              ),
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
                                            CommonStrings.verifyOtp,
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
                                          CommonText(
                                            CommonStrings.enter6digitMobile,
                                            textAlign: TextAlign.center,
                                            style: TextStyleConstants.regular(
                                              context,
                                              fontSize: 14,
                                              color: AppColors.defaultText,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          CommonText(
                                            "+${widget.params.countryCode.countryCode} ${widget.params.mobileNo}",
                                            textAlign: TextAlign.center,
                                            style: TextStyleConstants.semiBold(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.defaultText,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: CommonText(
                                              CommonStrings.changeNumber,
                                              textAlign: TextAlign.center,
                                              style: TextStyleConstants.regular(
                                                context,
                                                fontSize: 16,
                                                color: AppColors.orange,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Pinput(
                                              length: 6,
                                              autofocus: true,
                                              showCursor: true,
                                              toolbarEnabled: false,
                                              controller: textCodeController,
                                              scrollPadding: EdgeInsets.zero,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.send,
                                              separatorBuilder: (index) {
                                                return SizedBox(
                                                  width: 8,
                                                );
                                              },
                                              onCompleted: (value) {
                                                // BlocProvider.of<AuthenticationCubit>(context)
                                                //     .verify(
                                                //   SigninParams(
                                                //     username: '',
                                                //     password: '',
                                                //   ),
                                                // );
                                              },
                                              defaultPinTheme: PinTheme(
                                                height: 60,
                                                width: 60,
                                                textStyle:
                                                    TextStyleConstants.semiBold(
                                                  context,
                                                  fontSize: 16,
                                                  color: AppColors.black,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: AppColors.border,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              submittedPinTheme: PinTheme(
                                                height: 60,
                                                width: 60,
                                                textStyle:
                                                    TextStyleConstants.medium(
                                                  context,
                                                  fontSize: 16,
                                                  color: AppColors.black,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: AppColors.border,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextButton(
                                            onPressed: _canResend
                                                ? _onResendTap
                                                : null,
                                            child: Text(
                                              _canResend
                                                  ? "Resend OTP"
                                                  : "Resend Code in $_secondsLeft sec",
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          CommonButton(
                                            onPressed: () async {
                                              late VerifyOtpParams params;
                                              if (!formKey.currentState!
                                                  .validate()) {
                                                return;
                                              }

                                              params = VerifyOtpParams(
                                                mobileNo:
                                                    widget.params.mobileNo,
                                                otp: textCodeController.text,
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

                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              Constants.isBuyer == true
                                                  ? BlocProvider.of<
                                                              AuthenticationCubit>(
                                                          context)
                                                      .verifyOtpBuyer(params)
                                                  : BlocProvider.of<
                                                              AuthenticationCubit>(
                                                          context)
                                                      .verifyOtp(params);
                                            },
                                            text:
                                                CommonStrings.verifyAndContinue,
                                            textStyle:
                                                TextStyleConstants.medium(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
