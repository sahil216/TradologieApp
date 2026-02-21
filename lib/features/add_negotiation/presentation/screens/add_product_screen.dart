import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/choose_images_bottom_sheet.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_auction_supplier_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_detail_for_edit_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/cubit/add_negotiation_cubit.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/viewmodel/add_product_params.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/info_tile.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/negotiation_info_section.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/product_draft_card.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/selectable_circle_widget.dart';
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

  List<AddAuctionSupplierListData>? supplierList;
  List<AddAuctionSupplierListData> supplierListSelected = [];

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

  late AddAuctionItemParams params;

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

  Future<void> addAuctionSupplierList() async {
    await cubit.addAuctionSupplierList(widget.params.groupID);
  }

  final List<String> selected = [];

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

  File? packingImage;

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

  final imageController = ImagePickerController();

  @override
  void initState() {
    auctionDetailForEdit();
    getAuctionItemList();
    getAllList();
    addAuctionSupplierList();

    commodityController.text = widget.params.groupName;
    super.initState();
  }

  void clearForm() {
    _formKey.currentState?.reset();

    setState(() {
      selectedSubCommodity = null;
      selectedAttribute1 = null;
      selectedAttribute2 = null;
      selectedUnit = null;
      selectedPackingSize = null;
      selectedPackingType = null;

      qtyController.clear();
      messageController.clear();

      commodityKey = UniqueKey();
      subCommodityKey = UniqueKey();
      attr1Key = UniqueKey();
      attr2Key = UniqueKey();
      unitKey = UniqueKey();
      packingSizeKey = UniqueKey();
      packingTypeKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AddNegotiationCubit, AddNegotiationState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) async {
              if (state is AuctionDetailForEditSuccess) {
                auctionDetailData = state.data;
              }
              if (state is AuctionDetailForEditError) {
                CommonToast.showFailureToast(state.failure);
              }
              if (state is AuctionItemListSuccess) {
                auctionItemList = state.data;
              }
              if (state is AuctionItemListError) {
                auctionItemList = [];
                // CommonToast.showFailureToast(state.failure);
              }
              if (state is PackingImageUploadSuccess) {
                // cubit.addAuctionItem(params);
              }
              if (state is PackingImageUploadError) {}

              if (state is DeleteAuctionItemSuccess) {
                await getAuctionItemList();
                setState(() {});
              }
              if (state is DeleteAuctionItemError) {}
              if (state is AddAuctionItemSuccess) {
                await getAuctionItemList();
                clearForm();
              }
              if (state is AddAuctionItemError) {}
              if (state is AddAuctionSupplierListSuccess) {
                supplierList = state.data;
              }
              if (state is AddAuctionSupplierListError) {
                CommonToast.showFailureToast(state.failure);
              }
              if (state is AddAuctionSupplierSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.mainRoute, (route) => false);
              }
              if (state is AddAuctionSupplierError) {
                CommonToast.showFailureToast(state.failure);
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
        child: Stack(
          children: [
            AdaptiveScaffold(
              appBar: Constants.appBar(
                context,
                title: "Add Product for Negotiation",
                centerTitle: true,
              ),
              body: BlocBuilder<AddNegotiationCubit, AddNegotiationState>(
                  builder: (context, state) {
                if (state is AuctionDetailForEditIsLoading) {}
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
                              value: auctionDetailData?.deliveryLastDate
                                      .toString() ??
                                  ""),
                          InfoTile(
                              label: "Remarks",
                              value: auctionDetailData?.remarks ?? ""),
                          InfoTile(
                              label: "Inspection Agency",
                              value:
                                  auctionDetailData?.agencyCompanyName ?? ""),
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          addProductWidget(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    (auctionItemList == null || auctionItemList == [])
                        ? SizedBox.shrink()
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: auctionItemList?.length ?? 0,
                            separatorBuilder: (_, __) => SizedBox(
                              height: 12,
                            ),
                            itemBuilder: (context, index) {
                              return productDraftCard(auctionItemList?[index]);
                            },
                          ),
                    const SizedBox(height: 16),
                    (auctionItemList?.isEmpty ?? true)
                        ? SizedBox.shrink()
                        : addSupplier(),
                  ],
                );
              }),
            ),
            BlocBuilder<AddNegotiationCubit, AddNegotiationState>(
              buildWhen: (previous, current) {
                bool result = current != previous;

                // result = result &&
                //     (current is CreateAuctionIsLoading ||
                //         current is CreateAuctionSuccess ||
                //         current is CreateAuctionError ||
                //         current is AddUpdateAuctionIsLoading ||
                //         current is AddUpdateAuctionSuccess ||
                //         current is AddUpdateAuctionError);

                return result;
              },
              builder: (context, state) {
                if (state is AuctionDetailForEditIsLoading ||
                    state is AuctionItemListIsLoading ||
                    state is AddAuctionSupplierIsLoading ||
                    state is AddAuctionSupplierListIsLoading ||
                    state is AddAuctionItemIsLoading ||
                    state is DeleteAuctionItemIsLoading) {
                  return const CommonLoader();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
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
        SizedBox(
            height:
                (allListDetail?.packingTypeList?.isNotEmpty ?? false) ? 20 : 0),
        (allListDetail?.packingTypeList?.isNotEmpty ?? false)
            ? CommonDropdown<PackingTypeList>(
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
              )
            : SizedBox.shrink(),
        SizedBox(
            height:
                (allListDetail?.packingSizeList?.isNotEmpty ?? false) ? 20 : 0),
        (allListDetail?.packingSizeList?.isNotEmpty ?? false)
            ? CommonDropdown<PackingSizeList>(
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
              )
            : SizedBox.shrink(),
        const SizedBox(height: 20),
        // ImagePickerFormField(
        //   controller: imageController,
        //   label: "",
        //   hint: "Upload Packing image",
        //   validator: (file) {
        //     if (!imageController.hasImage) {
        //       return "Image is required";
        //     }
        //     return null;
        //   },
        //   onChanged: (file) {
        //     packingImage = file;
        //   },
        // ),
        // const SizedBox(height: 20),
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
              final params = AddAuctionItemParams(
                  token: await secureStorage
                          .read(AppStrings.apiVerificationCode) ??
                      "",
                  customerID:
                      await secureStorage.read(AppStrings.customerId) ?? "",
                  auctionID: widget.params.auctionID,
                  groupID: widget.params.groupID,
                  packingTypeID:
                      selectedPackingType?.packingTypeId.toString() ?? "",
                  packingSizeID:
                      selectedPackingSize?.packingSizeId.toString() ?? "",
                  categoryID: widget.params.groupID,
                  customCategory: selectedSubCommodity?.categoryName ?? "",
                  attributeValue1: selectedAttribute1?.attributeValueId ?? "",
                  attributeValue2: selectedAttribute2?.attributeValueId ?? "",
                  note: messageController.text,
                  qty: qtyController.text,
                  unit: selectedUnit?.unitName ?? '');
              cubit.addAuctionItem(params);
              // if (packingImage != null) {
              //   cubit.packingImageUpload(packingImage);
              // } else {

              // }
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

  Widget productDraftCard(AuctionItemListData? auctionItemListData) {
    return Container(
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
          (auctionItemListData?.packingImage == null ||
                  auctionItemListData?.packingImage == "")
              ? SizedBox.shrink()
              : ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.network(
                    auctionItemListData?.packingImage ?? "",
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
                    auctionItemListData?.groupName ?? "",
                    style: TextStyleConstants.semiBold(
                      context,
                    ),
                  ),
                  SizedBox(height: 4),
                  CommonText(
                    auctionItemListData?.customCategory ?? "",
                    style: TextStyleConstants.semiBold(
                      context,
                    ),
                  ),
                  SizedBox(height: 6),
                  CommonText(
                    "Packing Type & Size: ${auctionItemListData?.packingType} ${auctionItemListData?.packingSize}",
                    style: TextStyleConstants.medium(
                      context,
                    ),
                  ),
                  SizedBox(height: 6),
                  CommonText(
                    "Qty: ${auctionItemListData?.quantity}",
                    style: TextStyleConstants.medium(
                      context,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () async {
                await cubit.deleteAuctionItem(DeleteAuctionItemParams(
                    token: await secureStorage
                            .read(AppStrings.apiVerificationCode) ??
                        "",
                    customerID:
                        await secureStorage.read(AppStrings.customerId) ?? "",
                    auctionTranID:
                        auctionItemListData?.auctionTranId.toString() ?? ""));
                await getAuctionItemList();
                setState(() {});
              },
              icon: Icon(Icons.delete_outline, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget addSupplier() {
    return ExpandableSectionCard(
      index: 1,
      title: "Choose Supplier for Negotiation",
      controller: controller,
      scrollController: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SUPPLIER LIST
          SizedBox(
            height: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: supplierList?.length ?? 0,
              itemBuilder: (_, i) {
                final isSelected =
                    selected.contains(supplierList?[i].vendorName);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: AnimatedSelectableCircle(
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        isSelected
                            ? selected.remove(supplierList?[i].vendorName)
                            : selected.add(supplierList?[i].vendorName ?? "");
                        isSelected
                            ? supplierListSelected.remove(supplierList?[i])
                            : supplierListSelected.add(supplierList![i]);
                      });
                    },
                  ),
                  title: Text(supplierList?[i].vendorName ?? ""),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          CommonButton(
            text: "Submit Negotiation",
            onPressed: () async {
              final output = cubit.buildSupplierOutput(
                  supplierListSelected, widget.params.auctionID);

              showWarningDialog(context, () async {
                await cubit.addAuctionSupplier(AddAuctionSupplierParams(
                    token: await secureStorage
                            .read(AppStrings.apiVerificationCode) ??
                        "",
                    customerID:
                        await secureStorage.read(AppStrings.customerId) ?? "",
                    auctionID: widget.params.auctionID,
                    supplier: output));
              });
            },
          ),

          const SizedBox(height: 12),

          // CommonButton(
          //     text: "Clear all",
          //     onPressed: () {
          //       setState(() {
          //         selected.clear;
          //         supplierListSelected.clear();
          //       });
          //     }),
        ],
      ),
    );
  }

  void showWarningDialog(
    BuildContext context,
    void Function() onPressed,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: CommonText(
          "Are you sure you want to submit negotiation?",
          style: TextStyleConstants.semiBold(context),
        ),
        actions: [
          ElevatedButton(
            onPressed: onPressed,
            child: CommonText(
              "Yes",
              style: TextStyleConstants.semiBold(context),
            ),
          ),
        ],
      ),
    );
  }
}
