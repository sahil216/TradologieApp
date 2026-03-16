import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';

import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_seller_signin_usecase.dart';
import 'package:tradologie_app/injection_container.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/common_social_icons.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/authentication_cubit.dart';

class FmcgSellerSignin extends StatefulWidget {
  const FmcgSellerSignin({super.key});

  @override
  State<FmcgSellerSignin> createState() => _FmcgSellerSigninState();
}

class _FmcgSellerSigninState extends State<FmcgSellerSignin>
    with SingleTickerProviderStateMixin {
  final textEmailController = TextEditingController();
  final textPasswordController = TextEditingController();

  SecureStorageService secureStorageService = SecureStorageService();

  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is FmcgSellerSigninSuccess) {
              Constants.isFmcg = true;
              secureStorageService.write(AppStrings.isFmcg, "true");
              if (state.data.fmcgUserDetail?.fromDate != "-" &&
                  state.data.fmcgUserDetail?.toDate != "-") {
                Constants().hideSensitiveData = Constants().isTodayInRange(
                    DateTime.parse(state.data.fmcgUserDetail?.fromDate ?? ""),
                    DateTime.parse(state.data.fmcgUserDetail?.toDate ?? ""));
              } else {
                Constants().hideSensitiveData = true;
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.fmcgMainScreen,
                (route) => false,
              );
            }
            if (state is FmcgSellerSigninError) {
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
                                            );
                                            if (!context.mounted) {
                                              return;
                                            }
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();

                                            BlocProvider.of<
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
                                      SizedBox(height: 20),

                                      InkWell(
                                        onTap: () {
                                          sl<NavigationService>().pushNamed(
                                              Routes
                                                  .fmcgRegisterSellerDistributorForm,
                                              arguments: false);
                                        },
                                        child: Center(
                                          child: CommonText(
                                            "Register New Brand",
                                            style: TextStyleConstants.regular(
                                              context,
                                              fontSize: 16,
                                              color: AppColors.defaultText,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 20),
                                      // SizedBox(
                                      //   width: r.isTablet
                                      //       ? 420
                                      //       : double.infinity,
                                      //   child: CommonButton(
                                      //     onPressed: () {
                                      //       Navigator.pop(context);
                                      //     },
                                      //     text: CommonStrings
                                      //         .sendOtpViaWhatsapp,
                                      //     backgroundColor:
                                      //         AppColors.white,
                                      //     borderSide: BorderSide(
                                      //       color: AppColors
                                      //           .green, // or any color you want
                                      //       width: 2,
                                      //     ),
                                      //     icon: Image.asset(
                                      //         ImgAssets.whatsappIcon),
                                      //     textStyle:
                                      //         TextStyleConstants
                                      //             .medium(
                                      //       context,
                                      //       fontSize: 16,
                                      //       color: AppColors.black,
                                      //     ),
                                      //   ),
                                      // ),
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
                  if (state is FmcgSellerSigninIsLoading) {
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
