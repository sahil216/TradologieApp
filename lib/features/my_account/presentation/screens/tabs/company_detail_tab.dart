import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_date_picker.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/common_single_child_scroll_view.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class CompanyDetailTab extends StatefulWidget {
  const CompanyDetailTab({super.key});

  @override
  State<CompanyDetailTab> createState() => _CompanyDetailTabState();
}

class _CompanyDetailTabState extends State<CompanyDetailTab> {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  String? selectedCountry;
  DateTime? selectedDate;

  void getCompanyDetail() {}

  @override
  void initState() {
    super.initState();
    getCompanyDetail();
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
            if (state is CompanyDetailSuccess) {
              data = state.data;
            }
            if (state is CompanyDetailError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is CompanyDetailSuccess ||
                  current is CompanyDetailError ||
                  current is CompanyDetailIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is CompanyDetailError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getCompanyDetail();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getCompanyDetail();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return SafeArea(
            child: CommonSingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CommonTextField(
                        titleText: CommonStrings.vendorShortName,
                        hintText: CommonStrings.entervendorShortName,
                        textRequired: CommonStrings.entervendorShortName,
                        controller: TextEditingController(),
                        textInputType: TextInputType.name,
                        isEnable: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      titleText: CommonStrings.companyName,
                      hintText: CommonStrings.entercompanyName,
                      textRequired: CommonStrings.entercompanyName,
                      controller: TextEditingController(),
                      textInputType: TextInputType.text,
                      isEnable: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    // CommonBottomSheetSearchDropdown<String>(
                    //   label: CommonStrings.companyType,
                    //   hint: CommonStrings.selectcompanyType,
                    //   selectedItem: selectedCountry,
                    //   itemAsString: (item) => item,
                    //   onSearch: (value) async {
                    //     return [];
                    //   },
                    //   onChanged: (value) {
                    //     // selectedCountry = value;
                    //   },
                    //   validator: (value) {
                    //     // if (value == null) {
                    //     //   return "Country is required";
                    //     // }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    CommonTextField(
                      titleText: CommonStrings.companyGstNumber,
                      hintText: CommonStrings.entercompanyGstNumber,
                      textRequired: CommonStrings.entercompanyGstNumber,
                      controller: TextEditingController(),
                      textInputType: TextInputType.text,
                      isEnable: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      titleText: CommonStrings.companyPanNumber,
                      hintText: CommonStrings.entercompanyPanNumber,
                      textRequired: CommonStrings.entercompanyPanNumber,
                      controller: TextEditingController(),
                      textInputType: TextInputType.text,
                      isEnable: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    CommonCupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      label: CommonStrings.inCorporationDate,
                      hint: CommonStrings.selectinCorporationDate,
                      selectedDate: selectedDate,
                      minimumDate: DateTime(1900),
                      maximumDate: DateTime.now(),
                      onDateSelected: (date) {
                        selectedDate = date;
                        setState(() {});
                      },
                      validator: (date) {
                        if (date == null) {
                          return "Date of birth is required";
                        }
                        return null;
                      },
                      dateFormat: DateFormat('dd-MMM-yyyy'),
                    ),
                    SizedBox(height: 16),
                    // CommonBottomSheetSearchDropdown<String>(
                    //   label: CommonStrings.timeZone,
                    //   hint: CommonStrings.selecttimeZone,
                    //   selectedItem: selectedCountry,
                    //   itemAsString: (item) => item,
                    //   onSearch: (value) async {
                    //     return [];
                    //   },
                    //   onChanged: (value) {
                    //     // selectedCountry = value;
                    //   },
                    //   validator: (value) {
                    //     // if (value == null) {
                    //     //   return "Country is required";
                    //     // }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // CommonBottomSheetSearchDropdown<String>(
                    //   label: CommonStrings.country,
                    //   hint: CommonStrings.selectcountry,
                    //   selectedItem: selectedCountry,
                    //   itemAsString: (item) => item,
                    //   onSearch: (value) async {
                    //     return [];
                    //   },
                    //   onChanged: (value) {
                    //     // selectedCountry = value;
                    //   },
                    //   validator: (value) {
                    //     // if (value == null) {
                    //     //   return "Country is required";
                    //     // }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // CommonBottomSheetSearchDropdown<String>(
                    //   label: CommonStrings.stateProvince,
                    //   hint: CommonStrings.selectstateProvince,
                    //   selectedItem: selectedCountry,
                    //   itemAsString: (item) => item,
                    //   onSearch: (value) async {
                    //     return [];
                    //   },
                    //   onChanged: (value) {
                    //     // selectedCountry = value;
                    //   },
                    //   validator: (value) {
                    //     // if (value == null) {
                    //     //   return "Country is required";
                    //     // }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // CommonBottomSheetSearchDropdown<String>(
                    //   label: CommonStrings.city,
                    //   hint: CommonStrings.selectcity,
                    //   selectedItem: selectedCountry,
                    //   itemAsString: (item) => item,
                    //   onSearch: (value) async {
                    //     return [];
                    //   },
                    //   onChanged: (value) {
                    //     // selectedCountry = value;
                    //   },
                    //   validator: (value) {
                    //     // if (value == null) {
                    //     //   return "Country is required";
                    //     // }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // CommonBottomSheetSearchDropdown<String>(
                    //   label: CommonStrings.area,
                    //   hint: CommonStrings.selectarea,
                    //   selectedItem: selectedCountry,
                    //   itemAsString: (item) => item,
                    //   onSearch: (value) async {
                    //     return [];
                    //   },
                    //   onChanged: (value) {
                    //     // selectedCountry = value;
                    //   },
                    //   validator: (value) {
                    //     // if (value == null) {
                    //     //   return "Country is required";
                    //     // }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(height: 16),
                    CommonTextField(
                      titleText: CommonStrings.address,
                      hintText: CommonStrings.enteraddress,
                      textRequired: CommonStrings.enteraddress,
                      controller: TextEditingController(),
                      textInputType: TextInputType.text,
                      maxLines: 5,
                      height: 100,
                      isEnable: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      titleText: CommonStrings.zipPostalCode,
                      hintText: CommonStrings.enterzipPostalCode,
                      textRequired: CommonStrings.enterzipPostalCode,
                      controller: TextEditingController(),
                      textInputType: TextInputType.text,
                      isEnable: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
