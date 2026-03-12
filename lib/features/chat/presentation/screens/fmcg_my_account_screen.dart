import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';

import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_brands_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_distributor_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_seller_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../injection_container.dart';

class FmcgMyAccountScreen extends StatefulWidget {
  const FmcgMyAccountScreen({
    super.key,
  });

  @override
  State<FmcgMyAccountScreen> createState() => _FmcgMyAccountScreenState();
}

class _FmcgMyAccountScreenState extends State<FmcgMyAccountScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final nameController = TextEditingController();
  final brandNameController = TextEditingController();

  final distributionLocationController = TextEditingController();
  final companyNameController = TextEditingController();

  List<FmcgCountryCodeList> countryCodeList = [];
  FmcgCountryCodeList? selectedCountryCode;
  Key countryCodeKey = UniqueKey();
  List<FmcgBrandsList> brandsList = [];
  FmcgBrandsList? selectedBrand;
  Key brandKey = UniqueKey();

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
    final allItems = countryCodeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where(
            (e) => (e.name ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<FmcgBrandsList> fetchBrands(String filter, LoadProps? loadProps) {
    final allItems = brandsList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.brandName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  SecureStorageService secureStorageService = SecureStorageService();

  bool isSubmitted = false;

  AuthenticationCubit get authenticationCubit =>
      BlocProvider.of<AuthenticationCubit>(context);

  @override
  void initState() {
    super.initState();

    authenticationCubit.fmcgGetCountryCodeList(NoParams());
    authenticationCubit.fmcgBrandsList(NoParams());

    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenFade = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    );

    _screenScale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    _screenSlide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _screenController.forward();
    });
  }

  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  final showPassword = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AdaptiveScaffold(
        body: BlocListener<AuthenticationCubit, AuthenticationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if (state is FmcgRegisterSellerSuccess) {
              clearForm();
              sl<NavigationService>().pop();
              CommonToast.success(
                  "Thank You for Your Enquiry!Your enquiry has been successfully submitted. Our team will contact you shortly.");
            }
            if (state is FmcgRegisterSellerError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is FmcgRegisterDistributorSuccess) {
              clearForm();
              sl<NavigationService>().pop();
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
            if (state is FmcgBrandsListError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
          child: Stack(
            children: [
              FadeTransition(
                  opacity: _screenFade,
                  child: SlideTransition(
                    position: _screenSlide,
                    child: ScaleTransition(
                      scale: _screenScale,
                      child: CustomScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: [
                          CommonAppbar(
                            title: "My Account",
                            showBackButton: true,
                            showNotification: false,
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          titleText: "Brand Name",
                                          hintText: "Enter Brand Name",
                                          controller: brandNameController,
                                          textInputType:
                                              TextInputType.emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
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
                                            late FmcgRegisterSellerParams
                                                params;
                                            if (formKey.currentState!
                                                .validate()) {
                                              params = FmcgRegisterSellerParams(
                                                  token: Constants.token,
                                                  brandName:
                                                      brandNameController.text,
                                                  contactName:
                                                      nameController.text,
                                                  countryCode:
                                                      selectedCountryCode
                                                              ?.countryCode ??
                                                          '',
                                                  emailId: emailController.text,
                                                  mobileNo:
                                                      mobileController.text);
                                              if (!context.mounted) {
                                                return;
                                              }
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              BlocProvider.of<
                                                          AuthenticationCubit>(
                                                      context)
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              // BlocBuilder<AuthenticationCubit, AuthenticationState>(
              //   builder: (context, state) {
              //     if (state is FmcgRegisterSellerIsLoading ||
              //         state is FmcgRegisterDistributorIsLoading ||
              //         state is FmcgBrandsListIsLoading ||
              //         state is FmcgCountryCodeListIsLoading) {
              //       return Positioned.fill(child: const CommonLoader());
              //     }
              //     return SizedBox.shrink();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
