import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';

import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/register_usecase.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/masked_text_controller.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/common_single_child_scroll_view.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text/custom_text_rich.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/authentication_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final textFullNameController = TextEditingController();
  final textEmailController = TextEditingController();
  final textPhoneController = MaskedTextController(
    mask: '000 000 0000',
    text: "",
  );
  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();

  final termsAgree = ValueNotifier(false);
  final showPassword = ValueNotifier(false);

  bool isValidPhone = false;
  bool isValidEmail = false;
  bool isValidFullName = false;
  bool isValidPassword = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
          listener: (context, state) {
            if (state is RegisterSuccess) {
              CommonToast.success(CommonStrings.accountCreatedSuccessfully);

              Navigator.pop(context);
            }
            if (state is RegisterError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: CommonSingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
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
                                    CommonText(
                                      CommonStrings.signUp,
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
                                        titleText: CommonStrings.fullName,
                                        hintText: CommonStrings.enterFullName,
                                        textRequired:
                                            CommonStrings.enterFullName,
                                        controller: textFullNameController,
                                        textInputType: TextInputType.name,
                                        isEnable: true,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Full name is required";
                                          }

                                          return null;
                                        }),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    CommonTextField(
                                      titleText: CommonStrings.emailId,
                                      hintText: CommonStrings.enterEmail,
                                      textRequired: CommonStrings.enterEmail,
                                      controller: textEmailController,
                                      textInputType: TextInputType.emailAddress,
                                      isEnable: true,
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
                                    SizedBox(height: 12),
                                    CommonTextField(
                                      titleText: CommonStrings.mobileNumber,
                                      hintText: CommonStrings.enterMobileNumber,
                                      textRequired:
                                          CommonStrings.enterMobileNumber,
                                      controller: textPhoneController,
                                      textInputType: TextInputType.phone,
                                      isEnable: true,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String? value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Phone number is required";
                                        }
                                        if (value.replaceAll(' ', '').length <
                                            10) {
                                          return "Enter a valid phone number";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    CommonTextField(
                                      titleText: CommonStrings.password,
                                      hintText: CommonStrings.enterPassword,
                                      controller: textPasswordController,
                                      isObsecureText: showPassword.value == true
                                          ? false
                                          : true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          showPassword.value == true
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
                                    ),
                                    SizedBox(height: 12),
                                    CommonTextField(
                                      titleText: CommonStrings.confirmPassword,
                                      hintText:
                                          CommonStrings.enterConfirmPassword,
                                      controller: textConfirmPasswordController,
                                      textRequired: "Passwords do not match",
                                      isObsecureText: showPassword.value == true
                                          ? false
                                          : true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          showPassword.value == true
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
                                      validator: (String? val) {
                                        if (val == null || val.isEmpty) {
                                          return "Confirm Password is required";
                                        }
                                        if (val !=
                                            textPasswordController.text) {
                                          return "Passwords do not match";
                                        }
                                        return null;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                    ),
                                    SizedBox(height: 12),
                                    ValueListenableBuilder(
                                      valueListenable: termsAgree,
                                      builder: (context, value, _) {
                                        return Row(
                                          children: [
                                            Checkbox(
                                              value: termsAgree.value,
                                              onChanged: (value) {
                                                setState(() {
                                                  termsAgree.value =
                                                      value ?? false;
                                                });
                                              },
                                            ),
                                            Expanded(
                                              child: CustomTextRich(
                                                textAlign: TextAlign.center,
                                                children: [
                                                  TextSpan(
                                                    text: CommonStrings
                                                        .iAgreeToThe,
                                                    style: TextStyleConstants
                                                        .regular(
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
                                                                    .termsRoute,
                                                                arguments: EndPoints
                                                                    .privacyUrl);
                                                          },
                                                    text: CommonStrings
                                                        .privacyPolicy,
                                                    style: TextStyleConstants
                                                        .regular(
                                                      context,
                                                      fontSize: 15,
                                                      decorationThickness: 1,
                                                      decorationColor:
                                                          AppColors.black,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "& ",
                                                    style: TextStyleConstants
                                                        .regular(
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
                                                                    .termsRoute,
                                                                arguments:
                                                                    EndPoints
                                                                        .termsUrl);
                                                          },
                                                    text: CommonStrings
                                                        .termsOfUse,
                                                    style: TextStyleConstants
                                                        .regular(
                                                      context,
                                                      fontSize: 15,
                                                      decorationThickness: 1,
                                                      decorationColor:
                                                          AppColors.black,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " of ${CommonStrings.tradologieWebsitewithouthttp}",
                                                    style: TextStyleConstants
                                                        .regular(
                                                      context,
                                                      fontSize: 15,
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
                                      height: 22,
                                    ),
                                    CommonButton(
                                      onPressed: () {
                                        setState(() {});
                                        late RegisterParams registerParams;

                                        if ((formKey.currentState!
                                                .validate()) &&
                                            termsAgree.value == true) {
                                          registerParams = RegisterParams(
                                              email: textEmailController.text
                                                  .trim(),
                                              phone: textPhoneController.text
                                                  .replaceAll(' ', ''),
                                              username:
                                                  textFullNameController.text,
                                              token: "2018APR031848",
                                              password:
                                                  textPasswordController.text);

                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          BlocProvider.of<AuthenticationCubit>(
                                                  context)
                                              .register(registerParams);
                                        }
                                      },
                                      text: CommonStrings.signUp,
                                      textStyle: TextStyleConstants.medium(
                                        context,
                                        fontSize: 16,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // ContinueWhatsappWidget(
                                    //   onTap: () {},
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                buildWhen: (previous, current) {
                  bool result = current != previous;

                  result = result &&
                      (current is RegisterIsLoading ||
                          current is RegisterSuccess ||
                          current is RegisterError);

                  return result;
                },
                builder: (context, state) {
                  if (state is RegisterIsLoading) {
                    return const CommonLoader();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: CustomTextRich(
            textAlign: TextAlign.center,
            children: [
              TextSpan(
                text: CommonStrings.alreadyHaveAnAccount,
                style: TextStyleConstants.regular(
                  context,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(
                      context,
                    );
                  },
                text: CommonStrings.login,
                style: TextStyleConstants.regular(
                  context,
                  fontSize: 14,
                  decorationThickness: 1,
                  decorationColor: AppColors.orange,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
