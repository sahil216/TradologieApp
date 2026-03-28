import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';

import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_brands_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_brand_partnership_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_category_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_distribution_coverage_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_business_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_exporting_products_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_partnership_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_product_category_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_service_label_list.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_distributor_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_seller_usecase.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/authentication_cubit.dart';

class FmcgRegisterSellerDistributorForm extends StatefulWidget {
  final bool isDistributor;
  const FmcgRegisterSellerDistributorForm(
      {super.key, required this.isDistributor});

  @override
  State<FmcgRegisterSellerDistributorForm> createState() =>
      _FmcgRegisterSellerDistributorFormState();
}

class _FmcgRegisterSellerDistributorFormState
    extends State<FmcgRegisterSellerDistributorForm>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final brandNameController = TextEditingController();

  final distributionLocationController = TextEditingController();
  final partnerBrandNameController = TextEditingController();
  final specifyRequirementsController = TextEditingController();

  final companyNameController = TextEditingController();

  List<FmcgCountryCodeList> countryCodeList = [];
  FmcgCountryCodeList? selectedCountryCode;
  Key countryCodeKey = UniqueKey();
  List<FmcgBrandsList> brandsList = [];
  FmcgBrandsList? selectedBrand;
  Key brandKey = UniqueKey();

  Key fmcgSellerExportingProductsListKey = UniqueKey();
  Key fmcgSellerServiceLabelListKey = UniqueKey();
  Key fmcgSellerPartnershipTypeListKey = UniqueKey();
  Key fmcgSellerProductCategoryListKey = UniqueKey();
  Key fmcgSellerBusinessTypeListKey = UniqueKey();
  Key fmcgBuyerDistributionCoverageListKey = UniqueKey();
  Key fmcgBuyerBrandPartnershipTypeListKey = UniqueKey();
  Key fmcgBuyerCategoryListKey = UniqueKey();

  List<FmcgSellerExportingProductsList>? fmcgSellerExportingProductsList;
  FmcgSellerExportingProductsList? selectedFmcgSellerExportingProductsList;
  List<FmcgSellerServiceLabelList>? fmcgSellerServiceLabelList;
  FmcgSellerServiceLabelList? selectedFmcgSellerServiceLabelList;
  List<FmcgSellerPartnershipTypeList>? fmcgSellerPartnershipTypeList;
  FmcgSellerPartnershipTypeList? selectedFmcgSellerPartnershipTypeList;
  List<FmcgSellerProductCategoryList>? fmcgSellerProductCategoryList;
  FmcgSellerProductCategoryList? selectedFmcgSellerProductCategoryList;
  List<FmcgSellerBusinessTypeList>? fmcgSellerBusinessTypeList;
  FmcgSellerBusinessTypeList? selectedFmcgSellerBusinessTypeList;

  List<FmcgBuyerDistributionCoverageList>? fmcgBuyerDistributionCoverageList;
  FmcgBuyerDistributionCoverageList? selectedFmcgBuyerDistributionCoverageList;
  List<FmcgBuyerBrandPartnershipTypeList>? fmcgBuyerBrandPartnershipTypeList;
  FmcgBuyerBrandPartnershipTypeList? selectedFmcgBuyerBrandPartnershipTypeList;
  List<FmcgBuyerCategoryList>? fmcgBuyerCategoryList;
  FmcgBuyerCategoryList? selectedFmcgBuyerCategoryList;

  void getDropDownsData() async {
    if (widget.isDistributor == true) {
      await authenticationCubit.fmcgBuyerCategoryList(NoParams());
      await authenticationCubit.fmcgBuyerBrandPartnershipList(NoParams());
      await authenticationCubit.fmcgBuyerDistributionCoverageList(NoParams());
      await authenticationCubit.fmcgBrandsList(NoParams());
    } else {
      await authenticationCubit.fmcgSellerBusinessTypeList(NoParams());
      await authenticationCubit.fmcgSellerProductCategoryList(NoParams());
      await authenticationCubit.fmcgSellerPartnershipTypeList(NoParams());
      await authenticationCubit.fmcgSellerServiceLabelList(NoParams());
      await authenticationCubit.fmcgSellerExportingProductsList(NoParams());
    }
  }

  String model = '';
  String osVersionRelease = '';
  String deviceId = '';
  String manufacturer = '';
  String appVersion = '';

  void clearForm() {
    emailController.clear();
    mobileController.clear();
    nameController.clear();
    brandNameController.clear();
    distributionLocationController.clear();
    companyNameController.clear();
    selectedBrand = null;
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

  List<FmcgBrandsList> fetchBrands(String filter, LoadProps? loadProps) {
    final allItems = brandsList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.brandName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgBuyerCategoryList> fetchFmcgBuyerCategoryList(
      String filter, LoadProps? loadProps) {
    final allItems = fmcgBuyerCategoryList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgBuyerBrandPartnershipTypeList>
      fetchFmcgBuyerBrandPartnershipTypeList(
          String filter, LoadProps? loadProps) {
    final allItems = fmcgBuyerBrandPartnershipTypeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgBuyerDistributionCoverageList>
      fetchFmcgBuyerDistributionCoverageList(
          String filter, LoadProps? loadProps) {
    final allItems = fmcgBuyerDistributionCoverageList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerBusinessTypeList> fetchFmcgSellerBusinessTypeList(
      String filter, LoadProps? loadProps) {
    final allItems = fmcgSellerBusinessTypeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerProductCategoryList> fetchFmcgSellerProductCategoryList(
      String filter, LoadProps? loadProps) {
    final allItems = fmcgSellerProductCategoryList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerPartnershipTypeList> fetchFmcgSellerPartnershipTypeList(
      String filter, LoadProps? loadProps) {
    final allItems = fmcgSellerPartnershipTypeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerServiceLabelList> fetchFmcgSellerServiceLabelList(
      String filter, LoadProps? loadProps) {
    final allItems = fmcgSellerServiceLabelList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgSellerExportingProductsList> fetchFmcgSellerExportingProductsList(
      String filter, LoadProps? loadProps) {
    final allItems = fmcgSellerExportingProductsList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  SecureStorageService secureStorageService = SecureStorageService();

  bool isSubmitted = false;

  AuthenticationCubit get authenticationCubit =>
      BlocProvider.of<AuthenticationCubit>(context);

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPackageInfo();
    getDropDownsData();
    authenticationCubit.fmcgGetCountryCodeList(NoParams());
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  final deviceInfoPlugin = DeviceInfoPlugin();

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is FmcgRegisterSellerSuccess) {
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
              clearForm();

              CommonToast.success(
                  "Thank You for Your Enquiry!Your enquiry has been successfully submitted. Our team will contact you shortly.");
            }
            if (state is FmcgRegisterSellerError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is FmcgRegisterDistributorSuccess) {
              Constants.isFmcg = true;
              secureStorageService.write(AppStrings.isFmcg, "true");
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.fmcgMainScreen,
                (route) => false,
              );
              clearForm();

              CommonToast.success(
                  "Thank You for Your Interest in Becoming a Distributor! Your enquiry has been successfully submitted. Our team will review your details and contact you shortly.");
            }
            if (state is FmcgRegisterDistributorError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is FmcgCountryCodeListSuccess) {
              countryCodeList = state.data;

              setState(() {});
            }
            if (state is FmcgCountryCodeListError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is FmcgBrandsListSuccess) {
              brandsList = state.data;

              setState(() {});
            }
            if (state is FmcgBuyerCategoryListSuccess) {
              fmcgBuyerCategoryList = state.data;

              setState(() {});
            }
            if (state is FmcgBuyerBrandPartnershipTypeListSuccess) {
              fmcgBuyerBrandPartnershipTypeList = state.data;

              setState(() {});
            }
            if (state is FmcgBuyerDistributionCoverageListSuccess) {
              fmcgBuyerDistributionCoverageList = state.data;

              setState(() {});
            }
            if (state is FmcgSellerBusinessTypeListSuccess) {
              fmcgSellerBusinessTypeList = state.data;

              setState(() {});
            }
            if (state is FmcgSellerProductCategoryListSuccess) {
              fmcgSellerProductCategoryList = state.data;

              setState(() {});
            }
            if (state is FmcgSellerPartnershipTypeListSuccess) {
              fmcgSellerPartnershipTypeList = state.data;

              setState(() {});
            }
            if (state is FmcgSellerServiceLabelListSuccess) {
              fmcgSellerServiceLabelList = state.data;

              setState(() {});
            }
            if (state is FmcgSellerExportingProductsListSuccess) {
              fmcgSellerExportingProductsList = state.data;

              setState(() {});
            }
            if (state is FmcgBrandsListError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CommonAppbar(
                    title: widget.isDistributor
                        ? "Apply for Distributorship"
                        : "Register Your Brand",
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
                          widget.isDistributor
                              ? distributorForm()
                              : brandForm(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              BlocBuilder<AuthenticationCubit, AuthenticationState>(
                builder: (context, state) {
                  if (state is FmcgRegisterSellerIsLoading ||
                      state is FmcgRegisterDistributorIsLoading ||
                      state is FmcgBrandsListIsLoading ||
                      state is FmcgCountryCodeListIsLoading ||
                      state is FmcgBuyerCategoryListIsLoading ||
                      state is FmcgBuyerBrandPartnershipTypeListIsLoading ||
                      state is FmcgBuyerDistributionCoverageListIsLoading ||
                      state is FmcgSellerBusinessTypeListIsLoading ||
                      state is FmcgSellerProductCategoryListIsLoading ||
                      state is FmcgSellerPartnershipTypeListIsLoading ||
                      state is FmcgSellerServiceLabelListIsLoading ||
                      state is FmcgSellerExportingProductsListIsLoading) {
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

  Widget distributorForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          CommonTextField(
            titleText: "Full Name",
            hintText: "Enter Full Name",
            controller: nameController,
            textInputType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return "Required";
              }

              return null;
            },
          ),
          SizedBox(height: 12),
          CommonTextField(
            titleText: "Company Name ",
            hintText: "Enter Company Name ",
            controller: companyNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Required";
              }
              if (val.isEmailValid == false) {
                return "Enter valid email";
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
              return fetchCountryCode(filter, loadProps);
            },
            validator: (value) => value == null ? "Required" : null,
            selectedItem: null,
            itemAsString: (item) => item.countryText ?? "",
            onChanged: (item) {
              selectedCountryCode = item;
            },
            compareFn: (a, b) => a.countryText == b.countryText,
          ),
          SizedBox(height: 12),
          CommonTextField(
            titleText: "Mobile",
            hintText: "Enter Mobile",
            controller: mobileController,
            textInputType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Required";
              }

              return null;
            },
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgBrandsList>(
            label: 'Brand Name of Interest',
            hint: 'Select Brand Name of Interest',
            dropdownKey: countryCodeKey,
            asyncItems: (filter, loadProps) {
              return fetchBrands(filter, loadProps);
            },
            validator: (value) => value == null ? "Required" : null,
            selectedItem: null,
            itemAsString: (item) => item.brandName ?? "",
            onChanged: (item) {
              selectedBrand = item;
              setState(() {});
            },
            compareFn: (a, b) => a.brandName == b.brandName,
          ),
          SizedBox(height: 12),
          selectedBrand?.brandName == "Other"
              ? CommonTextField(
                  titleText: "Brand Name",
                  hintText: "Enter Brand Name",
                  controller: brandNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? val) {
                    if (val == null || val.isEmpty) {
                      return "Required";
                    }

                    return null;
                  },
                )
              : SizedBox.shrink(),
          SizedBox(height: 12),
          CommonTextField(
            titleText: "Preferred Distributorship Location",
            hintText: "Enter Preferred Distributorship Location",
            controller: distributionLocationController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Required";
              }

              return null;
            },
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgBuyerCategoryList>(
            label: 'Which FMCG categories are you interested in Distributing?',
            hint: 'Select FMCG categories.',
            dropdownKey: fmcgBuyerCategoryListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgBuyerCategoryList(filter, loadProps);
            },
            validator: (value) => value == null ? "Required" : null,
            selectedItem: null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgBuyerCategoryList = item;
              setState(() {});
            },
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgBuyerBrandPartnershipTypeList>(
            label: 'What type of brand Partnership are you interested in?',
            hint: 'Select Type of Brand Partnership.',
            dropdownKey: fmcgBuyerBrandPartnershipTypeListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgBuyerBrandPartnershipTypeList(filter, loadProps);
            },
            selectedItem: null,
            validator: (value) => value == null ? "Required" : null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgBuyerBrandPartnershipTypeList = item;
              setState(() {});
            },
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgBuyerDistributionCoverageList>(
            label: 'What is your distribution coverage?',
            hint: 'Select distribution coverage',
            dropdownKey: fmcgBuyerDistributionCoverageListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgBuyerDistributionCoverageList(filter, loadProps);
            },
            validator: (value) => value == null ? "Required" : null,
            selectedItem: null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgBuyerDistributionCoverageList = item;
              setState(() {});
            },
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonTextField(
            titleText: "Which brand(s) are you looking to partner with?",
            hintText: "Enter brand name looking to partner with?",
            controller: partnerBrandNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Required";
              }

              return null;
            },
          ),
          SizedBox(height: 12),
          CommonTextField(
            titleText: "Want to specify your requirement?",
            hintText: "MOQ, Margin Expectations, Territory, etc.",
            controller: specifyRequirementsController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
              late FmcgRegisterDistributorParams params;
              if (formKey.currentState!.validate()) {
                params = FmcgRegisterDistributorParams(
                  name: nameController.text,
                  mobile: mobileController.text,
                  email: emailController.text,
                  companyName: companyNameController.text,
                  interestedBrandName: (selectedBrand?.brandName == "Other")
                      ? brandNameController.text
                      : selectedBrand?.brandName ?? "",
                  perferredLocation: distributionLocationController.text,
                  countryCode: selectedCountryCode?.countryCode ?? '',
                  osType: Platform.isAndroid ? "Android" : "iOS",
                  fcmToken:
                      await secureStorageService.read(AppStrings.fcmToken) ??
                          "",
                  manufacturer: manufacturer,
                  model: model,
                  osVersionRelease: osVersionRelease,
                  appVersion: appVersion,
                  deviceId: deviceId,
                  fmcgCategory: selectedFmcgBuyerCategoryList?.name ?? '',
                  brandPartnershipType:
                      selectedFmcgBuyerBrandPartnershipTypeList?.name ?? '',
                  distributionCoverage:
                      selectedFmcgBuyerDistributionCoverageList?.name ?? '',
                  partnerBrand: partnerBrandNameController.text,
                  specifyRequirement: specifyRequirementsController.text,
                );
                if (!context.mounted) {
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();

                BlocProvider.of<AuthenticationCubit>(context)
                    .fmcgRegisterDistributor(params);
              }
            },
            text: "Register",
            textStyle: TextStyleConstants.medium(
              context,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget brandForm() {
    return Form(
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Required";
              }
              if (val.isEmailValid == false) {
                return "Enter valid email";
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
              return fetchCountryCode(filter, loadProps);
            },
            selectedItem: null,
            itemAsString: (item) => item.countryText ?? "",
            onChanged: (item) {
              selectedCountryCode = item;
            },
            validator: (item) => item == null ? "Required" : null,
            compareFn: (a, b) => a.countryText == b.countryText,
          ),
          SizedBox(height: 12),
          CommonTextField(
            titleText: "Mobile",
            hintText: "Enter Mobile",
            controller: mobileController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return "Required";
              }

              return null;
            },
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgSellerBusinessTypeList>(
            label: 'What Best describes your business?',
            hint: 'Select business.',
            dropdownKey: fmcgSellerBusinessTypeListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgSellerBusinessTypeList(filter, loadProps);
            },
            selectedItem: null,
            itemAsString: (item) => item.name ?? "",
            validator: (value) => value == null ? "Required" : null,
            onChanged: (item) {
              selectedFmcgSellerBusinessTypeList = item;
            },
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgSellerProductCategoryList>(
            label: 'Which product categories do you sell?',
            hint: 'Select product categories.',
            dropdownKey: fmcgSellerProductCategoryListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgSellerProductCategoryList(filter, loadProps);
            },
            selectedItem: null,
            validator: (value) => value == null ? "Required" : null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgSellerProductCategoryList = item;
            },
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgSellerPartnershipTypeList>(
            label: 'What type of Partnership are you seeking?',
            hint: 'Select type of Partnership.',
            dropdownKey: fmcgSellerPartnershipTypeListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgSellerPartnershipTypeList(filter, loadProps);
            },
            selectedItem: null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgSellerPartnershipTypeList = item;
            },
            validator: (value) => value == null ? "Required" : null,
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgSellerServiceLabelList>(
            label: 'Do you offer Private label / white label services',
            hint: 'Select services',
            dropdownKey: fmcgSellerServiceLabelListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgSellerServiceLabelList(filter, loadProps);
            },
            selectedItem: null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgSellerServiceLabelList = item;
            },
            validator: (value) => value == null ? "Required" : null,
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 12),
          CommonDropdown<FmcgSellerExportingProductsList>(
            label: 'Are you currently exporting your products?',
            hint: 'Select currently exporting products.',
            dropdownKey: fmcgSellerExportingProductsListKey,
            asyncItems: (filter, loadProps) {
              return fetchFmcgSellerExportingProductsList(filter, loadProps);
            },
            selectedItem: null,
            itemAsString: (item) => item.name ?? "",
            onChanged: (item) {
              selectedFmcgSellerExportingProductsList = item;
            },
            validator: (value) => value == null ? "Required" : null,
            compareFn: (a, b) => a.name == b.name,
          ),
          SizedBox(height: 20),
          CommonButton(
            onPressed: () async {
              late FmcgRegisterSellerParams params;
              if (formKey.currentState!.validate()) {
                params = FmcgRegisterSellerParams(
                  token: "2018APR031848",
                  brandName: brandNameController.text,
                  contactName: nameController.text,
                  countryCode: selectedCountryCode?.countryCode ?? '',
                  emailId: emailController.text,
                  mobileNo: mobileController.text,
                  osType: Platform.isAndroid ? "Android" : "iOS",
                  fcmToken:
                      await secureStorageService.read(AppStrings.fcmToken) ??
                          "",
                  manufacturer: manufacturer,
                  model: model,
                  osVersionRelease: osVersionRelease,
                  appVersion: appVersion,
                  deviceId: deviceId,
                  businessType: selectedFmcgSellerBusinessTypeList?.name ?? '',
                  productCategory:
                      selectedFmcgSellerProductCategoryList?.name ?? '',
                  partnershipType:
                      selectedFmcgSellerPartnershipTypeList?.name ?? '',
                  serviceLabel: selectedFmcgSellerServiceLabelList?.name ?? '',
                  exportingProducts:
                      selectedFmcgSellerExportingProductsList?.name ?? '',
                );
                if (!context.mounted) {
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();

                BlocProvider.of<AuthenticationCubit>(context)
                    .fmcgRegisterSeller(params);
              }
            },
            text: "Register",
            textStyle: TextStyleConstants.medium(
              context,
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
