import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/attribute_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/item_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/sub_commodity_list.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/post_vendor_stock_requirement.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

import '../../../../core/widgets/custom_text/text_style_constants.dart';

class PostStockRequirementScreen extends StatefulWidget {
  const PostStockRequirementScreen({super.key});

  @override
  State<PostStockRequirementScreen> createState() =>
      _PostStockRequirementScreenState();
}

class _PostStockRequirementScreenState
    extends State<PostStockRequirementScreen> {
  AllListDetail? allListDetail;
  List<CommodityList>? commodityList;

  CommodityList? selectedCommodity;
  SubCommodityList? selectedSubCommodity;
  AttributeList? selectedAttribute1;
  AttributeList? selectedAttribute2;
  ItemUnitList? selectedUnit;

  Key commodityKey = UniqueKey();
  Key subCommodityKey = UniqueKey();
  Key attr1Key = UniqueKey();
  Key attr2Key = UniqueKey();
  Key unitKey = UniqueKey();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController messageController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  List<CommodityList> fetchCommodity(String filter, LoadProps? loadProps) {
    final allItems = commodityList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.groupName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<SubCommodityList> fetchSubCommodity(
      String filter, LoadProps? loadProps) {
    final allItems = allListDetail?.categoryList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.categoryName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<AttributeList> fetchAttribute1(String filter, LoadProps? loadProps) {
    final allItems = allListDetail?.attribute1List ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => (e.attributeValueId ?? "")
            .toLowerCase()
            .contains(filter.toLowerCase()))
        .toList();
  }

  List<AttributeList> fetchAttribute2(String filter, LoadProps? loadProps) {
    final allItems = allListDetail?.attribute2List ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => (e.attributeValueId ?? "")
            .toLowerCase()
            .contains(filter.toLowerCase()))
        .toList();
  }

  List<ItemUnitList> fetchItemUnit(String filter, LoadProps? loadProps) {
    final allItems = allListDetail?.itemUnitList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.unitName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  final dropDownKey = GlobalKey<DropdownSearchState>();

  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  Future<void> getCommodityData() async {
    await dashboardCubit.getCommodityList(NoParams());
  }

  void clearForm() {
    _formKey.currentState?.reset();

    setState(() {
      selectedCommodity = null;
      selectedSubCommodity = null;
      selectedAttribute1 = null;
      selectedAttribute2 = null;
      selectedUnit = null;

      qtyController.clear();
      addressController.clear();
      messageController.clear();

      commodityKey = UniqueKey();
      subCommodityKey = UniqueKey();
      attr1Key = UniqueKey();
      attr2Key = UniqueKey();
      unitKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    getCommodityData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardCubit, DashboardState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GetCommodityListSuccess) {
              commodityList = state.data;
            }
            if (state is GetCommodityListError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is PostVendorStockRequirementSuccess) {
              CommonToast.success(
                  "Thank you for posting your requirement. Relevant sellers will be notified and you will receive quotes soon.");
              clearForm();
            }
            if (state is PostVendorStockRequirementError) {
              CommonToast.showFailureToast(state.failure);
            }

            if (state is GetAllListSuccess) {
              allListDetail = state.data;
              selectedSubCommodity = null;
              selectedAttribute1 = null;
              selectedAttribute2 = null;
              selectedUnit = null;
              subCommodityKey = UniqueKey();
              attr1Key = UniqueKey();
              attr2Key = UniqueKey();
              unitKey = UniqueKey();
            }
            if (state is GetAllListError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AdaptiveScaffold(
          appBar: Constants.appBar(
            context,
            title: 'Post ready to sell stock ',
            centerTitle: true,
          ),
          body: BlocBuilder<DashboardCubit, DashboardState>(
            buildWhen: (previous, current) {
              bool result = previous != current;
              result = result &&
                  (current is GetDashboardSuccess ||
                      current is GetDashboardError ||
                      current is GetDashboardIsLoading ||
                      current is GetAllListSuccess ||
                      current is GetAllListError ||
                      current is GetAllListIsLoading ||
                      current is PostVendorStockRequirementSuccess ||
                      current is PostVendorStockRequirementError ||
                      current is PostVendorStockRequirementIsLoading);
              return result;
            },
            builder: (context, state) {
              if (state is GetDashboardIsLoading) {
                return const CommonLoader();
              }
              // if (commodityList == null) {
              if (state is GetCommodityListError) {
                if (state.failure is NetworkFailure) {
                  return CustomErrorNetworkWidget(
                    onPress: () {
                      getCommodityData();
                    },
                  );
                } else if (state.failure is UserFailure) {
                  return CustomErrorWidget(
                    onPress: () {
                      getCommodityData();
                    },
                    errorText: state.failure.msg,
                  );
                }
              }
              //   return const CommonLoader();
              // }
              return Stack(
                children: [
                  SafeArea(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Column(
                            children: [
                              CommonDropdown<CommodityList>(
                                label: 'Commodity *',
                                hint: 'Select Commodity',
                                dropdownKey: commodityKey,
                                asyncItems: (filter, loadProps) {
                                  return fetchCommodity(filter, loadProps);
                                },
                                validator: (value) =>
                                    value == null ? "Required" : null,
                                selectedItem: null,
                                itemAsString: (item) {
                                  return item.groupName ?? "";
                                },
                                onChanged: (item) async {
                                  SecureStorageService secureStorage =
                                      SecureStorageService();

                                  final params = GetAllListParams(
                                      token: await secureStorage.read(
                                              AppStrings.apiVerificationCode) ??
                                          "",
                                      groupID: item?.groupId ?? "");
                                  selectedCommodity = item;

                                  dashboardCubit.getAllList(params);
                                },
                                compareFn: (a, b) => a.groupName == b.groupName,
                              ),
                              const SizedBox(height: 20),
                              CommonDropdown<SubCommodityList>(
                                label: 'Sub Commodity *',
                                hint: 'Select Sub Commodity',
                                dropdownKey: subCommodityKey,
                                asyncItems: (filter, loadProps) {
                                  return fetchSubCommodity(filter, loadProps);
                                },
                                selectedItem: null,
                                itemAsString: (item) => item.categoryName ?? "",
                                onChanged: (item) {
                                  selectedSubCommodity = item;
                                },
                                compareFn: (a, b) =>
                                    a.categoryId == b.categoryId,
                              ),
                              const SizedBox(height: 20),
                              CommonDropdown<AttributeList>(
                                label:
                                    '${allListDetail?.attribute1Header ?? "Attribute-1"} *',
                                hint:
                                    '${allListDetail?.attribute1Header ?? "Attribute-1"} *',
                                dropdownKey: attr1Key,
                                asyncItems: (filter, loadProps) {
                                  return fetchAttribute1(filter, loadProps);
                                },
                                selectedItem: null,
                                itemAsString: (item) =>
                                    item.attributeValue ?? "",
                                onChanged: (item) {
                                  selectedAttribute1 = item;
                                },
                                compareFn: (a, b) =>
                                    a.attributeValueId == b.attributeValueId,
                              ),
                              const SizedBox(height: 20),
                              CommonDropdown<AttributeList>(
                                label:
                                    '${allListDetail?.attribute2Header ?? "Attribute-2"} *',
                                hint:
                                    '${allListDetail?.attribute2Header ?? "Attribute-2"} *',
                                dropdownKey: attr2Key,
                                asyncItems: (filter, loadProps) {
                                  return fetchAttribute2(filter, loadProps);
                                },
                                selectedItem: null,
                                itemAsString: (item) =>
                                    item.attributeValue ?? "",
                                onChanged: (item) {
                                  selectedAttribute2 = item;
                                },
                                compareFn: (a, b) =>
                                    a.attributeValueId == b.attributeValueId,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: CommonDropdown<ItemUnitList>(
                                      label: 'Unit *',
                                      hint: 'Select Unit',
                                      dropdownKey: unitKey,
                                      asyncItems: (filter, loadProps) {
                                        return fetchItemUnit(filter, loadProps);
                                      },
                                      selectedItem: null,
                                      itemAsString: (item) =>
                                          item.unitName ?? "",
                                      onChanged: (item) {
                                        selectedUnit = item;
                                      },
                                      compareFn: (a, b) =>
                                          a.unitName == b.unitName,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: CommonTextField(
                                      titleText: CommonStrings.quantity,
                                      titleStyle:
                                          TextStyleConstants.semiBold(context),
                                      hintText: CommonStrings.enterQuantity,
                                      textRequired: CommonStrings.enterQuantity,
                                      controller: qtyController,
                                      backgroundColor: AppColors.transparent,
                                      textInputType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      isEnable: true,
                                      height: 45,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (String? value) {
                                        // if (value == null ||
                                        //     value.trim().isEmpty) {
                                        //   return "Required";
                                        // }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              CommonTextField(
                                titleText: CommonStrings.address,
                                titleStyle:
                                    TextStyleConstants.semiBold(context),
                                hintText: CommonStrings.enteraddress,
                                textRequired: CommonStrings.enteraddress,
                                controller: addressController,
                                backgroundColor: AppColors.transparent,
                                textInputType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                isEnable: true,
                                height: 45,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Required";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              CommonTextField(
                                titleText: CommonStrings.message,
                                hintText: CommonStrings.enterMessage,
                                titleStyle:
                                    TextStyleConstants.semiBold(context),
                                textRequired: CommonStrings.enterMessage,
                                controller: messageController,
                                textInputType: TextInputType.text,
                                isEnable: true,
                                backgroundColor: AppColors.transparent,
                                height: 100,
                                autovalidateMode: AutovalidateMode.disabled,
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Required";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<DashboardCubit, DashboardState>(
                    buildWhen: (previous, current) {
                      bool result = current != previous;

                      result = result &&
                          (current is GetAllListIsLoading ||
                              current is GetAllListSuccess ||
                              current is GetAllListError ||
                              current is GetCommodityListIsLoading ||
                              current is GetCommodityListSuccess ||
                              current is GetCommodityListError ||
                              current is PostVendorStockRequirementIsLoading ||
                              current is PostVendorStockRequirementSuccess ||
                              current is PostVendorStockRequirementError);

                      return result;
                    },
                    builder: (context, state) {
                      if (state is GetAllListIsLoading ||
                          state is GetCommodityListIsLoading ||
                          state is PostVendorStockRequirementIsLoading) {
                        return const CommonLoader();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: CommonButton(
                onPressed: () async {
                  SecureStorageService secureStorage = SecureStorageService();

                  if (selectedCommodity != null &&
                      selectedSubCommodity != null &&
                      selectedAttribute1 != null &&
                      selectedAttribute2 != null &&
                      selectedUnit != null &&
                      qtyController.text.isNotEmpty &&
                      addressController.text.isNotEmpty &&
                      messageController.text.isNotEmpty) {
                    final params = PostVendorStockRequirementParams(
                        token: await secureStorage
                                .read(AppStrings.apiVerificationCode) ??
                            "",
                        commodityID: selectedCommodity?.groupId ?? "",
                        subCommodityID: selectedSubCommodity?.categoryId ?? "",
                        attribute1: selectedAttribute1?.attributeValueId ?? "",
                        attribute2: selectedAttribute2?.attributeValueId ?? "",
                        quantity: qtyController.text,
                        quantityUnit: selectedUnit?.unitName ?? "",
                        otherSpecifications: messageController.text,
                        stockLocation: addressController.text,
                        userId:
                            await secureStorage.read(AppStrings.customerId) ??
                                "");

                    dashboardCubit.postVendorStockRequirement(params);
                  } else {
                    CommonToast.error(CommonStrings.enterAllDetails);
                  }
                },
                text: "Submit",
                textStyle: TextStyleConstants.medium(
                  context,
                  fontSize: 16,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
