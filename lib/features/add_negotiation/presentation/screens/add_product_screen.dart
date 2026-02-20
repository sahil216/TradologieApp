import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
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
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_detail_for_edit_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/cubit/add_negotiation_cubit.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/viewmodel/add_product_params.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/info_tile.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/negotiation_info_section.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/product_draft_card.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/supplier_selector.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/attribute_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/item_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/packing_size_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/packing_type_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/sub_commodity_list.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

import '../widget/expandable_section_card.dart';

class AddProductScreen extends StatefulWidget {
  final AddProductParams params;
  const AddProductScreen({super.key, required this.params});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final controller = ExpandableController(defaultOpened: {0, 1});

  AuctionDetailForEditData? auctionDetailData;
  List<AuctionItemListData>? auctionItemList;
  bool showProductForm = false;
  AllListDetail? allListDetail;

  final ScrollController scrollController = ScrollController();

  SecureStorageService secureStorage = SecureStorageService();

  AddNegotiationCubit get cubit =>
      BlocProvider.of<AddNegotiationCubit>(context);
  DashboardCubit get dashboardCubit => BlocProvider.of<DashboardCubit>(context);

  Future<void> auctionDetailForEdit() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);

    await cubit.auctionDetailForEdit(AuctionDetailForEditParams(
        token: token ?? "",
        auctionID: widget.params.auctionID,
        userTimeZone: Constants.timeZone));
  }

  Future<void> getAuctionItemList() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);

    await cubit.auctionItemList(AuctionItemListParams(
        token: token ?? '', auctionID: widget.params.auctionID));
  }

  Future<void> getAllList() async {
    SecureStorageService secureStorage = SecureStorageService();

    final params = GetAllListParams(
        token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
        groupID: widget.params.groupID);

    dashboardCubit.getAllList(params);
  }

  SubCommodityList? selectedSubCommodity;
  AttributeList? selectedAttribute1;
  AttributeList? selectedAttribute2;
  ItemUnitList? selectedUnit;
  PackingTypeList? selectedPackingType;
  PackingSizeList? selectedPackingSize;

  Key commodityKey = UniqueKey();
  Key subCommodityKey = UniqueKey();
  Key attr1Key = UniqueKey();
  Key attr2Key = UniqueKey();
  Key unitKey = UniqueKey();
  Key packingTypeKey = UniqueKey();
  Key packingSizeKey = UniqueKey();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController messageController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController commodityController = TextEditingController();

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

  List<PackingTypeList> fetchPackingType(String filter, LoadProps? loadProps) {
    final allItems = allListDetail?.packingTypeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.packingValue ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<PackingSizeList> fetchPackingSize(String filter, LoadProps? loadProps) {
    final allItems = allListDetail?.packingSizeList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => (e.packingSizeValue ?? "")
            .toLowerCase()
            .contains(filter.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    auctionDetailForEdit();
    getAuctionItemList();
    getAllList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AddNegotiationCubit, AddNegotiationState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is AuctionDetailForEditSuccess) {
                auctionDetailData = state.data;
              }
              if (state is AuctionDetailForEditError) {
                CommonToast.showFailureToast(state.failure);
              }
              if (state is AuctionItemListSuccess) {
                // auctionDetailData = state.data;
              }
              if (state is AuctionItemListError) {
                // CommonToast.showFailureToast(state.failure);
              }
            },
          ),
          BlocListener<DashboardCubit, DashboardState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is GetAllListSuccess) {
                allListDetail = state.data;
              }
              if (state is GetAllListError) {
                CommonToast.showFailureToast(state.failure);
              }
            },
          ),
        ],
        child: AdaptiveScaffold(
          appBar: Constants.appBar(
            context,
            title: "Add Product for Negotiation",
            centerTitle: true,
          ),
          body: BlocBuilder<AddNegotiationCubit, AddNegotiationState>(
              builder: (context, state) {
            if (state is AuctionDetailForEditIsLoading) {
              return const CommonLoader();
            }
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                ExpandableSectionCard(
                  index: 0,
                  title: "Negotiation Details",
                  controller: controller,
                  scrollController: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoTile(
                          label: "Negotiation Reference Code",
                          value: auctionDetailData?.auctionCode ?? ""),
                      InfoTile(
                          label: "Negotiation Name",
                          value: auctionDetailData?.auctionName ?? ""),
                      InfoTile(
                          label: "Location of Delivery",
                          value: auctionDetailData?.deliveryAddress ?? ""),
                      InfoTile(
                          label: "Port of Discharge",
                          value: auctionDetailData?.portOfDischarge ?? ""),
                      InfoTile(
                          label: "State of Delivery",
                          value: auctionDetailData?.deliveryState ?? ""),
                      InfoTile(
                          label: "Payment Term",
                          value: auctionDetailData?.paymentTerm ?? ""),
                      InfoTile(
                          label: "Currency",
                          value: auctionDetailData?.currencyName ?? ""),
                      InfoTile(
                          label: "Partial Delivery",
                          value: auctionDetailData?.partialDelivery ?? ""),
                      InfoTile(
                          label: "Status",
                          value: auctionDetailData?.status ?? ""),
                      InfoTile(
                          label: "Preffered Date and time of Enquiry",
                          value: auctionDetailData?.preferredDate ?? ""),
                      InfoTile(
                          label: "Total Quantity",
                          value: auctionDetailData?.totalQuantity ?? ""),
                      InfoTile(
                          label: "Min Order Quantity per Supplier",
                          value: auctionDetailData?.minQuantity ?? ""),
                      InfoTile(
                          label: "Last Date Of Delivery",
                          value:
                              auctionDetailData?.deliveryLastDate.toString() ??
                                  ""),
                      InfoTile(
                          label: "Remarks",
                          value: auctionDetailData?.remarks ?? ""),
                      InfoTile(
                          label: "Inspection Agency",
                          value: auctionDetailData?.agencyCompanyName ?? ""),
                      SizedBox(height: 8),
                      CommonButton(
                        text: "Add Product for Negotiation",
                        onPressed: () {
                          setState(() {
                            // showProductForm = !showProductForm;
                            controller.toggle(2);
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      CommonButton(
                        text: "Edit Negotiation",
                        onPressed: () {},
                      ),
                      addProductWidget(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                (auctionItemList == null || auctionItemList == [])
                    ? SizedBox.shrink()
                    : productDraftCard(),
                SupplierSelector(
                  index: 1,
                  controller: controller,
                  scrollController: scrollController,
                ),
              ],
            );
          }),
        ));
  }

  Widget addProductWidget() {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final expanded = controller.isOpen(2);

        return RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [],
            ),
            child: ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: expanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: _buildFormBody(),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormBody() {
    return Column(
      children: [
        const SizedBox(height: 20),
        CommonTextField(
          // titleText: "Commodity",
          hintText: "Commodity",
          titleStyle: TextStyleConstants.semiBold(context),

          controller: commodityController,
          textInputType: TextInputType.text,
          isEnable: false,
          backgroundColor: AppColors.transparent,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (String? value) {
            return null;
          },
        ),
        const SizedBox(height: 10),
        CommonDropdown<SubCommodityList>(
          label: '',
          hint: 'Select Grade',
          dropdownKey: subCommodityKey,
          asyncItems: (filter, loadProps) {
            return fetchSubCommodity(filter, loadProps);
          },
          selectedItem: null,
          itemAsString: (item) => item.categoryName ?? "",
          onChanged: (item) {
            selectedSubCommodity = item;
          },
          compareFn: (a, b) => a.categoryId == b.categoryId,
        ),
        const SizedBox(height: 20),
        CommonDropdown<AttributeList>(
          label: '',
          hint: allListDetail?.attribute1Header ?? "Type-1",
          dropdownKey: attr1Key,
          asyncItems: (filter, loadProps) {
            return fetchAttribute1(filter, loadProps);
          },
          selectedItem: null,
          itemAsString: (item) => item.attributeValue ?? "",
          onChanged: (item) {
            selectedAttribute1 = item;
          },
          compareFn: (a, b) => a.attributeValueId == b.attributeValueId,
        ),
        const SizedBox(height: 20),
        CommonDropdown<AttributeList>(
          label: '',
          hint: allListDetail?.attribute2Header ?? "Type-2",
          dropdownKey: attr2Key,
          asyncItems: (filter, loadProps) {
            return fetchAttribute2(filter, loadProps);
          },
          selectedItem: null,
          itemAsString: (item) => item.attributeValue ?? "",
          onChanged: (item) {
            selectedAttribute2 = item;
          },
          compareFn: (a, b) => a.attributeValueId == b.attributeValueId,
        ),
        const SizedBox(height: 20),
        CommonDropdown<ItemUnitList>(
          label: '',
          hint: 'Select Unit',
          dropdownKey: unitKey,
          asyncItems: (filter, loadProps) {
            return fetchItemUnit(filter, loadProps);
          },
          selectedItem: null,
          itemAsString: (item) => item.unitName ?? "",
          onChanged: (item) {
            selectedUnit = item;
          },
          compareFn: (a, b) => a.unitName == b.unitName,
        ),
        SizedBox(height: 20),
        CommonTextField(
          // titleText: CommonStrings.quantity,
          titleStyle: TextStyleConstants.semiBold(context),
          hintText: CommonStrings.enterQuantity,
          textRequired: CommonStrings.enterQuantity,
          controller: qtyController,
          backgroundColor: AppColors.transparent,
          textInputType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isEnable: true,
          height: 45,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? value) {
            // if (value == null ||
            //     value.trim().isEmpty) {
            //   return "Required";
            // }

            return null;
          },
        ),
        const SizedBox(height: 20),
        CommonDropdown<PackingTypeList>(
          label: '',
          hint: 'Select Packing Type',
          dropdownKey: packingTypeKey,
          asyncItems: (filter, loadProps) {
            return fetchPackingType(filter, loadProps);
          },
          selectedItem: null,
          itemAsString: (item) => item.packingValue ?? "",
          onChanged: (item) {
            selectedPackingType = item;
          },
          compareFn: (a, b) => a.packingTypeId == b.packingTypeId,
        ),
        const SizedBox(height: 20),
        CommonDropdown<PackingSizeList>(
          label: '',
          hint: 'Select Packing Size',
          dropdownKey: packingSizeKey,
          asyncItems: (filter, loadProps) {
            return fetchPackingSize(filter, loadProps);
          },
          selectedItem: null,
          itemAsString: (item) => item.packingSizeValue ?? "",
          onChanged: (item) {
            selectedPackingSize = item;
          },
          compareFn: (a, b) => a.packingSizeId == b.packingSizeId,
        ),
        const SizedBox(height: 20),
        CommonTextField(
          // titleText: "",
          hintText: CommonStrings.enterMessage,
          titleStyle: TextStyleConstants.semiBold(context),
          textRequired: CommonStrings.enterMessage,
          controller: messageController,
          textInputType: TextInputType.text,
          isEnable: true,
          backgroundColor: AppColors.transparent,

          autovalidateMode: AutovalidateMode.disabled,
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return "Required";
            }

            return null;
          },
        ),
        const SizedBox(height: 10),
        CommonButton(
          onPressed: () async {
            SecureStorageService secureStorage = SecureStorageService();

            if (selectedSubCommodity != null &&
                selectedAttribute1 != null &&
                selectedAttribute2 != null &&
                selectedUnit != null &&
                qtyController.text.isNotEmpty &&
                messageController.text.isNotEmpty) {
              // final params = AddCustomerRequirementParams(
              //     token: await secureStorage
              //             .read(AppStrings.apiVerificationCode) ??
              //         "",
              //     commodityID: selectedCommodity?.groupId ?? "",
              //     subCommodityID: selectedSubCommodity?.categoryId ?? "",
              //     attribute1: selectedAttribute1?.attributeValueId ?? "",
              //     attribute2: selectedAttribute2?.attributeValueId ?? "",
              //     quantity: qtyController.text,
              //     quantityUnit: selectedUnit?.unitName ?? "",
              //     otherSpecifications: messageController.text,
              //     userId: await secureStorage.read(AppStrings.customerId) ??
              //         "");

              // dashboardCubit.addCustomerRequirement(params);
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
      ],
    );
  }

  Widget productDraftCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: .06),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              "https://images.unsplash.com/photo-1586201375761-83865001e31c",
              height: 110,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    "Basmati Rice",
                    style: TextStyleConstants.semiBold(
                      context,
                    ),
                  ),
                  SizedBox(height: 4),
                  CommonText(
                    "1121 Raw Wand Rice",
                    style: TextStyleConstants.semiBold(
                      context,
                    ),
                  ),
                  SizedBox(height: 6),
                  CommonText(
                    "Packing Type & Size: BOPP (5 KG)",
                    style: TextStyleConstants.medium(
                      context,
                    ),
                  ),
                  SizedBox(height: 6),
                  CommonText(
                    "Qty: 160",
                    style: TextStyleConstants.medium(
                      context,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.delete_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
