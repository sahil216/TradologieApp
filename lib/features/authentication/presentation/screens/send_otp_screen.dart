import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_social_icons.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/phone_number_widget.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_single_child_scroll_view.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text/custom_text_rich.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../injection_container.dart';
import '../cubit/authentication_cubit.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});
  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final textMobileController = TextEditingController();
  final textFullNameController = TextEditingController();
  List<CountryCodeList>? countryCodeList;
  var params;
  CountryCodeList? countryCode;

  bool isSubmitted = false;
  final termsAgree = ValueNotifier(false);
  final showPassword = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  AuthenticationCubit get authenticationCubit =>
      BlocProvider.of<AuthenticationCubit>(context);
  @override
  void initState() {
    authenticationCubit.getCountryCodeList(NoParams());
    super.initState();
  }

  @override
  void dispose() {
    textMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is SendOtpSuccess) {
              if (state.isResend == false) {
                Navigator.pushNamed(context, Routes.verifyOtpScreen,
                    arguments: params);
              } else {
                Constants.showSuccessToast(
                    context: context, msg: CommonStrings.otpSentSuccessfully);
              }
            }
            if (state is SendOtpError) {
              Constants.showFailureToast(state.failure);
            }
            if (state is GetCountryCodeListSuccess) {
              countryCodeList = state.data;
              countryCode = countryCodeList
                  ?.firstWhere((element) => element.countryCode == "91");
              setState(() {});
            }
            if (state is GetCountryCodeListError) {
              Constants.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final r = Responsive(context);
                  return ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: ValueListenableBuilder(
                        valueListenable: showPassword,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: r.value(
                                    mobile: r.screenHeight * 0.35,
                                    tablet: r.screenHeight * 0.4),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Constants.isBuyer == true
                                        ? const AssetImage(
                                            ImgAssets.buyerLoginImage)
                                        : const AssetImage(
                                            ImgAssets.sellerLoginImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: CommonSingleChildScrollView(
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            r.isTablet ? 600 : double.infinity,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              r.value(mobile: 20, tablet: 32),
                                        ),
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
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 16,
                                                          tablet: 24)),
                                                  CommonText(
                                                    CommonStrings
                                                        .sendOtpPunchLine,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyleConstants
                                                        .medium(
                                                      context,
                                                      fontSize: r.value(
                                                          mobile: 24,
                                                          tablet: 30),
                                                      color:
                                                          AppColors.defaultText,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 16,
                                                          tablet: 24)),
                                                  CommonTextField(
                                                      titleText:
                                                          CommonStrings.name,
                                                      hintText: CommonStrings
                                                          .enterName,
                                                      textRequired:
                                                          CommonStrings
                                                              .enterName,
                                                      controller:
                                                          textFullNameController,
                                                      textInputType:
                                                          TextInputType.name,
                                                      isEnable: true,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator:
                                                          (String? value) {
                                                        if (value == null ||
                                                            value
                                                                .trim()
                                                                .isEmpty) {
                                                          return "Full name is required";
                                                        }

                                                        return null;
                                                      }),
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 16,
                                                          tablet: 24)),
                                                  CountryPhoneField(
                                                    initialCountry: countryCodeList
                                                            ?.firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .countryCode ==
                                                                    "91") ??
                                                        CountryCodeList(
                                                            countryName:
                                                                "India",
                                                            countryCode: "91"),
                                                    countryList:
                                                        countryCodeList ?? [],
                                                    controller:
                                                        textMobileController,
                                                    hintText: CommonStrings
                                                        .enterMobileNumber,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        textMobileController
                                                            .text = value;
                                                      });
                                                    },
                                                    onCountryChanged: (value) {
                                                      setState(() {
                                                        countryCode = value;
                                                      });
                                                    },
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Phone cannot be empty";
                                                      }
                                                      if (value.length < 10 &&
                                                          countryCode
                                                                  ?.countryCode ==
                                                              "91") {
                                                        return "Phone must be at least 10 digits";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 16,
                                                          tablet: 24)),
                                                  ValueListenableBuilder(
                                                    valueListenable: termsAgree,
                                                    builder:
                                                        (context, value, _) {
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                            value: termsAgree
                                                                .value,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                termsAgree
                                                                        .value =
                                                                    value ??
                                                                        false;
                                                              });
                                                            },
                                                          ),
                                                          Expanded(
                                                            child:
                                                                CustomTextRich(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              children: [
                                                                TextSpan(
                                                                  text: CommonStrings
                                                                      .iAgreeToThe,
                                                                  style: TextStyleConstants
                                                                      .regular(
                                                                    context,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {
                                                                          Constants.launch(
                                                                              EndPoints.privacyUrl);
                                                                        },
                                                                  text: CommonStrings
                                                                      .privacyPolicy,
                                                                  style: TextStyleConstants
                                                                      .regular(
                                                                    context,
                                                                    fontSize:
                                                                        15,
                                                                    decorationThickness:
                                                                        1,
                                                                    decorationColor:
                                                                        AppColors
                                                                            .black,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: " & ",
                                                                  style: TextStyleConstants
                                                                      .regular(
                                                                    context,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  recognizer:
                                                                      TapGestureRecognizer()
                                                                        ..onTap =
                                                                            () {
                                                                          Constants
                                                                              .launch(
                                                                            EndPoints.termsUrl,
                                                                          );
                                                                        },
                                                                  text: CommonStrings
                                                                      .termsOfUse,
                                                                  style: TextStyleConstants
                                                                      .regular(
                                                                    context,
                                                                    fontSize:
                                                                        15,
                                                                    decorationThickness:
                                                                        1,
                                                                    decorationColor:
                                                                        AppColors
                                                                            .black,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 16,
                                                          tablet: 24)),
                                                  SizedBox(
                                                    width: r.isTablet
                                                        ? 420
                                                        : double.infinity,
                                                    child: CommonButton(
                                                      onPressed:
                                                          termsAgree.value ==
                                                                  true
                                                              ? () async {
                                                                  if (textMobileController
                                                                          .text
                                                                          .isNotEmpty &&
                                                                      textFullNameController
                                                                          .text
                                                                          .isNotEmpty) {
                                                                    params = SendOtpParams(
                                                                        mobileNo:
                                                                            textMobileController
                                                                                .text,
                                                                        countryCode:
                                                                            countryCode ??
                                                                                CountryCodeList(),
                                                                        name: textFullNameController
                                                                            .text);
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                    Constants.isBuyer ==
                                                                            true
                                                                        ? BlocProvider.of<AuthenticationCubit>(context).sendOtpBuyer(
                                                                            params,
                                                                            false)
                                                                        : BlocProvider.of<AuthenticationCubit>(context).sendOtp(
                                                                            params,
                                                                            false);
                                                                  } else {
                                                                    Constants.showErrorToast(
                                                                        context:
                                                                            context,
                                                                        msg:
                                                                            "Please Enter the Details to Continue");
                                                                  }
                                                                }
                                                              : () {
                                                                  Constants.showErrorToast(
                                                                      context:
                                                                          context,
                                                                      msg:
                                                                          "Please accept Terms and Conditions");
                                                                },
                                                      text: CommonStrings
                                                          .sendOtpViaWhatsapp,
                                                      backgroundColor:
                                                          AppColors.white,
                                                      borderSide: BorderSide(
                                                        color: AppColors
                                                            .green, // or any color you want
                                                        width: 2,
                                                      ),
                                                      icon: Image.asset(
                                                          ImgAssets
                                                              .whatsappIcon),
                                                      textStyle:
                                                          TextStyleConstants
                                                              .medium(
                                                        context,
                                                        fontSize: 16,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 20,
                                                          tablet: 28)),
                                                  CustomTextRich(
                                                    textAlign: TextAlign.center,
                                                    children: [
                                                      TextSpan(
                                                        text: CommonStrings
                                                            .alreadyHaveAnAccount,
                                                        style:
                                                            TextStyleConstants
                                                                .semiBold(
                                                          context,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    Routes
                                                                        .signinRoute);
                                                              },
                                                        text:
                                                            CommonStrings.login,
                                                        style:
                                                            TextStyleConstants
                                                                .semiBold(
                                                          context,
                                                          fontSize: 15,
                                                          decorationThickness:
                                                              1,
                                                          color:
                                                              AppColors.orange,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: r.value(
                                                          mobile: 20,
                                                          tablet: 28)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CommonSocialIcons(),
                            ],
                          );
                        }),
                  );
                },
              ),
              if (Navigator.canPop(context)) ...[
                Positioned(
                  top: Responsive(context).screenHeight * 0.01,
                  left: 16,
                  child: GestureDetector(
                    onTap: () {
                      sl<NavigationService>().pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen: (previous, current) {
                  bool result = current != previous;
                  result = result &&
                      (current is SendOtpIsLoading ||
                          current is SendOtpError ||
                          current is SendOtpSuccess);
                  return result;
                },
                builder: (context, state) {
                  if (state is SendOtpIsLoading) {
                    return CommonLoader();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
