import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/utils/masked_text_controller.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/custom_text/common_text_widget.dart';
import '../../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class LoginControlTab extends StatefulWidget {
  const LoginControlTab({super.key});

  @override
  State<LoginControlTab> createState() => _LoginControlTabState();
}

class _LoginControlTabState extends State<LoginControlTab> {
  bool? data = false;

  final textFullNameController = TextEditingController();
  final textEmailController = TextEditingController();
  final textPhoneController = MaskedTextController(
    mask: '000 000 0000',
    text: "",
  );
  final textPasswordController = TextEditingController();
  final textConfirmPasswordController = TextEditingController();

  final showPassword = ValueNotifier(false);

  bool isValidPhone = false;
  bool isValidEmail = false;
  bool isValidFullName = false;
  bool isValidPassword = false;
  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getLoginControl() {}

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getLoginControl();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is SaveLoginControlSuccess) {
              data = state.data;
            }
            if (state is SaveLoginControlError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is SaveLoginControlSuccess ||
                  current is SaveLoginControlError ||
                  current is SaveLoginControlIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is SaveLoginControlError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getLoginControl();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getLoginControl();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return SafeArea(
            child: CommonSingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CommonTextField(
                              titleText: CommonStrings.fullName,
                              hintText: CommonStrings.enterFullName,
                              textRequired: CommonStrings.enterFullName,
                              controller: textFullNameController,
                              textInputType: TextInputType.name,
                              isEnable: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Full name is required";
                                }

                                return null;
                              }),
                          SizedBox(
                            height: 16,
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
                              if (value == null || value.trim().isEmpty) {
                                return "Email is required";
                              }
                              if (value.isEmailValid == false) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CommonTextField(
                            titleText: CommonStrings.mobileNumber,
                            hintText: CommonStrings.enterMobileNumber,
                            textRequired: CommonStrings.enterMobileNumber,
                            controller: textPhoneController,
                            textInputType: TextInputType.phone,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Phone number is required";
                              }
                              if (value.replaceAll(' ', '').length < 10) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CommonTextField(
                            titleText: CommonStrings.password,
                            hintText: CommonStrings.enterPassword,
                            controller: textPasswordController,
                            isObsecureText:
                                showPassword.value == true ? false : true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword.value == true
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.grayText,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword.value = !showPassword.value;
                                });
                              },
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(height: 16),
                          CommonTextField(
                            titleText: CommonStrings.confirmPassword,
                            hintText: CommonStrings.enterConfirmPassword,
                            controller: textConfirmPasswordController,
                            textRequired: "Passwords do not match",
                            isObsecureText:
                                showPassword.value == true ? false : true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword.value == true
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.grayText,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword.value = !showPassword.value;
                                });
                              },
                            ),
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return "Confirm Password is required";
                              }
                              if (val != textPasswordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(height: 16),
                          CommonTextField(
                            titleText: CommonStrings.profileUpload,
                            hintText: CommonStrings.enterprofileUpload,
                            textRequired: CommonStrings.enterprofileUpload,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            prefixIcon: GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: Responsive(context).screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: CommonText(
                                      "Choose File",
                                      style: TextStyleConstants.semiBold(
                                          context,
                                          fontSize: 14,
                                          color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              // if (value == null || value.trim().isEmpty) {
                              //   return "Email is required";
                              // }
                              // if (value.isEmailValid == false) {
                              //   return "Enter a valid email";
                              // }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CommonButton(
                            onPressed: () {},
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
