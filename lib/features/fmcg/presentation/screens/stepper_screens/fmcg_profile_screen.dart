import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

import '../../../../../core/widgets/common_drop_down.dart';

class FmcgProfileScreen extends StatefulWidget {
  const FmcgProfileScreen({super.key});

  @override
  State<FmcgProfileScreen> createState() => _FmcgProfileScreenState();
}

class _FmcgProfileScreenState extends State<FmcgProfileScreen>
    with SingleTickerProviderStateMixin {
  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final brandNameController = TextEditingController();

  final distributionLocationController = TextEditingController();
  final companyNameController = TextEditingController();

  List<FmcgCountryCodeList> countryCodeList = [];
  FmcgCountryCodeList? selectedCountryCode;
  Key countryCodeKey = UniqueKey();
  Key brandKey = UniqueKey();

  final showPassword = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  void clearForm() {
    emailController.clear();
    mobileController.clear();
    nameController.clear();
    brandNameController.clear();
    distributionLocationController.clear();
    companyNameController.clear();
    selectedCountryCode = null;
    countryCodeKey = UniqueKey();
    brandKey = UniqueKey();
    setState(() {});
  }

  List<FmcgCountryCodeList> fetchCountryCode(
      String filter, LoadProps? loadProps) {
    final allItems = countryCodeList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  bool isSubmitted = false;

  void getDistributorList() async {
    await chatCubit.getDistributorList(NoParams());
  }

  @override
  void initState() {
    super.initState();
    getDistributorList();
  }

  Future<void> _refreshChats() async {
    getDistributorList(); // your API call
  }

  void toggle(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = null;
      } else {
        expandedIndex = index;
      }
    });
  }

  int? expandedIndex;

  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is DistributorListSuccess) {
            // distributorList = state.data;
          }
          if (state is DistributorListError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CommonTextField(
                                    titleText: "Brand Name",
                                    hintText: "Enter Brand Name",
                                    controller: brandNameController,
                                    textInputType: TextInputType.emailAddress,
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
                                    titleText: "Name/Firm name",
                                    hintText: "Enter Name/Firm name",
                                    controller: nameController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  CommonTextField(
                                    titleText: "Email",
                                    hintText: "Enter Email",
                                    controller: emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  CommonDropdown<FmcgCountryCodeList>(
                                    label: 'Country Code',
                                    hint: 'Select Country Code',
                                    dropdownKey: countryCodeKey,
                                    asyncItems: (filter, loadProps) {
                                      return fetchCountryCode(
                                          filter, loadProps);
                                    },
                                    selectedItem: null,
                                    itemAsString: (item) =>
                                        item.countryText ?? "",
                                    onChanged: (item) {
                                      selectedCountryCode = item;
                                    },
                                    compareFn: (a, b) =>
                                        a.countryText == b.countryText,
                                  ),
                                  SizedBox(height: 12),
                                  CommonTextField(
                                    titleText: "Mobile",
                                    hintText: "Enter Mobile",
                                    controller: mobileController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (String? val) {
                                      if (val == null || val.isEmpty) {
                                        return "Required";
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  CommonButton(
                                    onPressed: () async {
                                      // late FmcgRegisterSellerParams params;
                                      // if (formKey.currentState!.validate()) {
                                      //   params = FmcgRegisterSellerParams(
                                      //       token: "2018APR031848",
                                      //       brandName:
                                      //           brandNameController.text,
                                      //       contactName: nameController.text,
                                      //       countryCode: selectedCountryCode
                                      //               ?.countryCode ??
                                      //           '',
                                      //       emailId: emailController.text,
                                      //       mobileNo: mobileController.text);
                                      //   if (!context.mounted) {
                                      //     return;
                                      //   }
                                      //   FocusManager.instance.primaryFocus
                                      //       ?.unfocus();

                                      //   BlocProvider.of<AuthenticationCubit>(
                                      //           context)
                                      //       .fmcgRegisterSeller(params);
                                      // }
                                    },
                                    text: "Submits",
                                    textStyle: TextStyleConstants.medium(
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
                  ],
                );
              },
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is DistributorListIsLoading) {
                  return Positioned.fill(child: const CommonLoader());
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
