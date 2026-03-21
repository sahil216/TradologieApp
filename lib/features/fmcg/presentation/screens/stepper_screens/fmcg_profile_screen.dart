import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_date_picker.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_gender.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_title.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';
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

  FmcgGetSellerProfile? fmcgGetSellerProfile;

  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final brandNameController = TextEditingController();

  List<FmcgCountryCodeList> countryCodeList = [];
  FmcgCountryCodeList? selectedCountryCode;
  FmcgSellerTitle? selectedTitle;
  FmcgSellerGender? selectedGender;
  Key countryCodeKey = UniqueKey();
  Key titleKey = UniqueKey();
  Key genderKey = UniqueKey();
  Key brandKey = UniqueKey();

  final showPassword = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  DateTime? dateOfBirth;

  // void clearForm() {
  //   emailController.clear();
  //   mobileController.clear();
  //   nameController.clear();
  //   brandNameController.clear();

  //   selectedCountryCode = null;
  //   countryCodeKey = UniqueKey();
  //   brandKey = UniqueKey();
  //   setState(() {});
  // }

  List<FmcgCountryCodeList> fetchCountryCode(
      String filter, LoadProps? loadProps) {
    final allItems = countryCodeList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerTitle> fetchSalutation(String filter, LoadProps? loadProps) {
    final allItems = fmcgGetSellerProfile?.fmcgSellerTitle ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.titleName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerGender> fetchGender(String filter, LoadProps? loadProps) {
    final allItems = fmcgGetSellerProfile?.fmcgSellerGender ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.genderName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  bool isSubmitted = false;

  void getProfileData() async {
    GetSellerProfileParams params = GetSellerProfileParams(
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      loginID: await secureStorage.read(AppStrings.userId) ?? "",
      deviceID: Constants.deviceID,
    );

    await chatCubit.getSellerProfile(params);
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
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
          if (state is GetSellerProfileSuccess) {
            fmcgGetSellerProfile = state.data;
          }
          if (state is GetSellerProfileError) {
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
                                  CommonDropdown<FmcgSellerTitle>(
                                    label: 'Title',
                                    hint: 'Select Title',
                                    dropdownKey: titleKey,
                                    asyncItems: (filter, loadProps) {
                                      return fetchSalutation(filter, loadProps);
                                    },
                                    selectedItem: null,
                                    itemAsString: (item) =>
                                        item.titleName ?? "",
                                    onChanged: (item) {
                                      selectedTitle = item;
                                    },
                                    compareFn: (a, b) =>
                                        a.titleName == b.titleName,
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
                                  SizedBox(height: 12),
                                  CommonDropdown<FmcgSellerGender>(
                                    label: 'Gender',
                                    hint: 'Select Gender',
                                    dropdownKey: genderKey,
                                    asyncItems: (filter, loadProps) {
                                      return fetchGender(filter, loadProps);
                                    },
                                    selectedItem: null,
                                    itemAsString: (item) =>
                                        item.genderName ?? "",
                                    onChanged: (item) {
                                      selectedGender = item;
                                    },
                                    compareFn: (a, b) =>
                                        a.genderName == b.genderName,
                                  ),
                                  SizedBox(height: 12),
                                  CommonDatePicker(
                                    label: "Date of Birth",
                                    hint: "(yyyy/mm/dd)",
                                    type: PickerType.dateTime,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    onChanged: (value) {
                                      dateOfBirth = value;
                                    },
                                    validator: (value) {
                                      if (value == null) return "Required";
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  CommonButton(
                                    onPressed: () async {
                                      late UpdateSellerProfileParams params;
                                      if (formKey.currentState!.validate()) {
                                        params = UpdateSellerProfileParams(
                                            token: await secureStorage.read(
                                                    AppStrings
                                                        .apiVerificationCode) ??
                                                "",
                                            loginID: '',
                                            titleID: '',
                                            genderID: '',
                                            profileImage: '',
                                            password: '',
                                            mobile: '',
                                            email: '',
                                            dob: '',
                                            name: '',
                                            isImage: null);
                                        if (!context.mounted) {
                                          return;
                                        }
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        BlocProvider.of<AuthenticationCubit>(
                                                context)
                                            .fmcgRegisterSeller(params);
                                      }
                                    },
                                    text: "Submit",
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
