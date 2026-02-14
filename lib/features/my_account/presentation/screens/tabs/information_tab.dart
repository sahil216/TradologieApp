import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/my_account/domain/entities/get_information_detail.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:tradologie_app/features/my_account/presentation/screens/widgets/common_toggle_button.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/custom_text/common_text_widget.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class InformationTab extends StatefulWidget {
  const InformationTab({super.key});

  @override
  State<InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<InformationTab> {
  GetInformationDetail? data;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  int selectedManufacturer = 0;
  int selectedTrader = 0;

  Future<void> getInformation() async {
    await cubit.getInformation(NoParams());
  }

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getInformation();
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
            if (state is GetInformationSuccess) {
              data = state.data;
            }
            if (state is GetInformationError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is SaveInformationSuccess) {
              // data = state.data;
            }
            if (state is SaveInformationError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is GetInformationSuccess ||
                  current is GetInformationError ||
                  current is GetInformationIsLoading ||
                  current is SaveInformationSuccess ||
                  current is SaveInformationError ||
                  current is SaveInformationIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is GetInformationError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getInformation();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getInformation();
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
                              titleText: CommonStrings.name,
                              hintText: CommonStrings.enterName,
                              textRequired: CommonStrings.enterName,
                              controller: TextEditingController(),
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
                            titleText: CommonStrings.vendorCode,
                            hintText: CommonStrings.enterVendorCode,
                            textRequired: CommonStrings.enterVendorCode,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          SizedBox(height: 16),
                          CommonTextField(
                            height: 100,
                            titleText: CommonStrings.description,
                            hintText: CommonStrings.enterdescription,
                            textRequired: CommonStrings.enterdescription,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            maxLines: 5,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (String? value) {
                              // if (value == null || value.trim().isEmpty) {
                              //   return "Phone number is required";
                              // }
                              // if (value.replaceAll(' ', '').length < 10) {
                              //   return "Enter a valid phone number";
                              // }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CommonTextField(
                            titleText: CommonStrings.vendorLogo,
                            hintText: CommonStrings.enterVendorLogo,
                            textRequired: CommonStrings.enterVendorLogo,
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
                          CommonTextField(
                            titleText: CommonStrings.eBrochure,
                            hintText: CommonStrings.entereBrochure,
                            textRequired: CommonStrings.entereBrochure,
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
                          CommonTextField(
                            titleText: CommonStrings.annualTurnOver,
                            hintText: CommonStrings.enterannualTurnOver,
                            textRequired: CommonStrings.enterannualTurnOver,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          CommonTextField(
                            titleText: CommonStrings.yearOfEstablishment,
                            hintText: CommonStrings.enteryearOfEstablishment,
                            textRequired:
                                CommonStrings.enteryearOfEstablishment,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          CommonTextField(
                            titleText: CommonStrings.certifications,
                            hintText: CommonStrings.entercertifications,
                            textRequired: CommonStrings.entercertifications,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          CommonTextField(
                            titleText: CommonStrings.areaOfOperation,
                            hintText: CommonStrings.enterareaOfOperation,
                            textRequired: CommonStrings.enterareaOfOperation,
                            controller: TextEditingController(),
                            textInputType: TextInputType.text,
                            isEnable: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CommonText(CommonStrings.manufacturer),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CommonToggleButton(
                                    labels: const ["Yes", "No"],
                                    selectedIndex: selectedManufacturer,
                                    onChanged: (int value) {
                                      setState(() {
                                        selectedManufacturer = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: CommonText(CommonStrings.trader),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: CommonToggleButton(
                                    labels: const ["Yes", "No"],
                                    selectedIndex: selectedTrader,
                                    onChanged: (int value) {
                                      setState(() {
                                        selectedTrader = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CommonButton(
                            onPressed: () {},
                            text: CommonStrings.submit,
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
