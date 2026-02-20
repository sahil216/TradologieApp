import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_update_auction_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/currency_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/customer_address_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/inspection_agency_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_update_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/viewmodel/add_product_params.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

import '../../../../core/error/network_failure.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../../../core/widgets/common_date_picker.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../cubit/add_negotiation_cubit.dart';

class AddNegotiationDetailsScreen extends StatefulWidget {
  final String groupID;
  const AddNegotiationDetailsScreen({super.key, required this.groupID});

  @override
  State<AddNegotiationDetailsScreen> createState() =>
      _AddNegotiationDetailsScreenState();
}

class _AddNegotiationDetailsScreenState
    extends State<AddNegotiationDetailsScreen> {
  List<CommodityList>? categoryList;
  List<InspectionAgencyList>? inspectionAgencyList;
  List<CurrencyList>? currencyList;
  List<CustomerAddressList>? customerAddressList;
  List<String> paymentTermList = ["LC", "ESCROW"];
  List<String> partialDeliveryList = ["Allowed", "Not Allowed"];
  CreateAuctionDetail? createAuctionDetail;

  CommodityList? selectedCommodity;

  DateTime? enquiryDate;
  DateTime? dispatchDate;

  TextEditingController negotiationNameController = TextEditingController();
  TextEditingController auctionCodeController = TextEditingController();
  TextEditingController stateOfDeliveryController = TextEditingController();
  TextEditingController portOfDischargeController = TextEditingController();
  TextEditingController totalQuantityController = TextEditingController();
  TextEditingController minOrderQuantityController = TextEditingController();
  TextEditingController deliveryTermsController = TextEditingController();
  TextEditingController bankerNameAndAddressController =
      TextEditingController();

  InspectionAgencyList? selectedInspectionAgency;
  CustomerAddressList? selectedLocationDelivery;
  String selectedPaymentTerm = "";
  String selectedPartialDelivery = "";
  CurrencyList? selectedCurrency;

  late AddUpdateAuctionParams params;

  SecureStorageService secureStorage = SecureStorageService();

  Key categoryKey = UniqueKey();

  final _formKey = GlobalKey<FormState>();

  List<InspectionAgencyList> fetchInspectionAgency(
      String filter, LoadProps? loadProps) {
    final allItems = inspectionAgencyList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => (e.inspectionCompanyName ?? "")
            .toLowerCase()
            .contains(filter.toLowerCase()))
        .toList();
  }

  List<CurrencyList> fetchCurrency(String filter, LoadProps? loadProps) {
    final allItems = currencyList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.currencyName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<CustomerAddressList> fetchAddress(String filter, LoadProps? loadProps) {
    final allItems = customerAddressList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.addressValue ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<String> fetchPaymentTerm(String filter, LoadProps? loadProps) {
    final allItems = paymentTermList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => (e).toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  List<String> fetchPartialDelivery(String filter, LoadProps? loadProps) {
    final allItems = partialDeliveryList;
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) => (e).toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  final dropDownKey = GlobalKey<DropdownSearchState>();

  AddNegotiationCubit get cubit =>
      BlocProvider.of<AddNegotiationCubit>(context);

  Future<void> createAuction() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);
    final customerId = await secureStorage.read(AppStrings.customerId);

    await cubit.createAuction(CreateAuctionParams(
        token: token ?? "",
        groupID: widget.groupID,
        customerId: customerId ?? ""));
  }

  Future<void> auctionDetailForEdit() async {
    final token = await secureStorage.read(AppStrings.apiVerificationCode);

    await cubit.auctionDetailForEdit(AuctionDetailForEditParams(
        token: token ?? "", auctionID: "1", userTimeZone: ""));
  }

  void clearForm() {
    _formKey.currentState?.reset();

    setState(() {
      selectedCommodity = null;

      categoryKey = UniqueKey();
    });
  }

  @override
  void initState() {
    createAuction();
    // auctionDetailForEdit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddNegotiationCubit, AddNegotiationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is CreateAuctionSuccess) {
              setState(() {
                createAuctionDetail = state.data;
                inspectionAgencyList =
                    createAuctionDetail?.inspectionAgencyList;
                currencyList = createAuctionDetail?.currencyList;
                customerAddressList = createAuctionDetail?.customerAddressList;
                auctionCodeController.text =
                    createAuctionDetail?.auctionCode ?? "";
              });
            }
            if (state is CreateAuctionError) {
              CommonToast.showFailureToast(state.failure);
            }
            if (state is AddUpdateAuctionSuccess) {
              Navigator.pushNamed(context, Routes.addProductScreen,
                  arguments: AddProductParams(
                      auctionID: state.data.auctionId ?? "",
                      groupID: widget.groupID));
            }
            if (state is AddUpdateAuctionError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AdaptiveScaffold(
          appBar: Constants.appBar(context,
              title: 'Add Negotiation', centerTitle: true, actions: []),
          body: BlocBuilder<AddNegotiationCubit, AddNegotiationState>(
            builder: (context, state) {
              if (state is GetCategoryError) {
                if (state.failure is NetworkFailure) {
                  return CustomErrorNetworkWidget(
                    onPress: () {
                      // getCategory();
                    },
                  );
                } else if (state.failure is UserFailure) {
                  return CustomErrorWidget(
                    onPress: () {
                      // getCategory();
                    },
                    errorText: state.failure.msg,
                  );
                }
              }

              return Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: CommonSingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            CommonTextField(
                              titleText: "Negotiation Reference Code",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Negotiation Reference Code",
                              textRequired: "Enter Negotiation Reference Code",
                              controller: auctionCodeController,
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.text,
                              inputFormatters: [],
                              isEnable: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CommonTextField(
                              titleText: "Negotiation Name",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Negotiation Name",
                              textRequired: "Enter Negotiation Name",
                              controller: negotiationNameController,
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.text,
                              inputFormatters: [],
                              isEnable: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CommonDropdown<InspectionAgencyList>(
                              label: 'Inspection Agency ',
                              hint: 'Select Inspection Agency',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchInspectionAgency(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) =>
                                  item.inspectionCompanyName ?? "",
                              onChanged: (item) async {
                                selectedInspectionAgency = item;
                              },
                              compareFn: (a, b) =>
                                  a.inspectionAgencyId == b.inspectionAgencyId,
                            ),
                            const SizedBox(height: 12),
                            CommonDropdown<CustomerAddressList>(
                              label: 'Location of Delivery',
                              hint: 'Select Location of Delivery',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchAddress(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.address ?? "",
                              onChanged: (item) async {
                                selectedLocationDelivery = item;
                              },
                              compareFn: (a, b) => a.address == b.address,
                            ),
                            const SizedBox(height: 12),
                            CommonTextField(
                              titleText: "State of Delivery",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter State of Delivery",
                              textRequired: "Enter State of Delivery",
                              controller: stateOfDeliveryController,
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.text,
                              inputFormatters: [],
                              isEnable: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CommonTextField(
                              titleText: "Port of Discharge",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Port of Discharge",
                              textRequired: "Enter Port of Discharge",
                              controller: portOfDischargeController,
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.text,
                              inputFormatters: [],
                              isEnable: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CommonDropdown<String>(
                              label: 'Payment Term',
                              hint: 'Select Payment Term',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchPaymentTerm(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item,
                              onChanged: (item) async {
                                selectedPaymentTerm = item ?? "";
                                setState(() {});
                              },
                              compareFn: (a, b) => a == b,
                            ),
                            selectedPaymentTerm == "LC"
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: CommonTextField(
                                      titleText: "Banker Name and Address",
                                      titleStyle:
                                          TextStyleConstants.semiBold(context),
                                      hintText: "Enter Banker Name and Address",
                                      textRequired:
                                          "Enter Banker Name and Address",
                                      controller:
                                          bankerNameAndAddressController,
                                      backgroundColor: AppColors.transparent,
                                      textInputType: TextInputType.text,
                                      inputFormatters: [],
                                      isEnable: true,
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
                                  )
                                : SizedBox.shrink(),
                            const SizedBox(height: 12),
                            CommonDropdown<CurrencyList>(
                              label: 'Currency',
                              hint: 'Select Currency',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchCurrency(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.currencyName ?? "",
                              onChanged: (item) async {
                                selectedCurrency = item;
                              },
                              compareFn: (a, b) =>
                                  a.currencyName == b.currencyName,
                            ),
                            const SizedBox(height: 12),
                            CommonDropdown<String>(
                              label: 'Partial Delivery',
                              hint: 'Select Partial Delivery',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchPartialDelivery(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item,
                              onChanged: (item) async {
                                selectedPartialDelivery = item ?? "";
                              },
                              compareFn: (a, b) => a == b,
                            ),
                            const SizedBox(height: 12),
                            CommonDatePicker(
                              label: "Preferred Date and Time of Enquiry ",
                              hint: "(yyyy/mm/dd HH:mm)",
                              type: PickerType.dateTime,
                              firstDate: DateTime.now(),
                              onChanged: (value) {
                                enquiryDate = value;
                              },
                              validator: (value) {
                                if (value == null) return "Required";
                                return null;
                              },
                            ),
                            CommonTextField(
                              titleText: "Total quantity",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Total quantity",
                              textRequired: "Enter Total quantity",
                              controller: totalQuantityController,
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              isEnable: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CommonTextField(
                              titleText: "Min Order Quantity per Supplier",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Min Order Quantity per Supplier",
                              textRequired:
                                  "Enter Min Order Quantity per Supplier",
                              controller: minOrderQuantityController,
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              isEnable: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Required";
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CommonDatePicker(
                              label: "Last Date of Dispatch",
                              hint: "yyyy/mm/dd",
                              type: PickerType.date,
                              firstDate: DateTime.now(),
                              onChanged: (value) {
                                dispatchDate = value;
                              },
                              validator: (value) {
                                if (value == null) return "Required";
                                return null;
                              },
                            ),
                            CommonTextField(
                              titleText: "Delivery Terms",
                              hintText: "Enter Delivery Terms",
                              titleStyle: TextStyleConstants.semiBold(context),
                              textRequired: "Enter Delivery Terms",
                              controller: deliveryTermsController,
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
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<AddNegotiationCubit, AddNegotiationState>(
                    buildWhen: (previous, current) {
                      bool result = current != previous;

                      result = result &&
                          (current is CreateAuctionIsLoading ||
                              current is CreateAuctionSuccess ||
                              current is CreateAuctionError ||
                              current is AddUpdateAuctionIsLoading ||
                              current is AddUpdateAuctionSuccess ||
                              current is AddUpdateAuctionError);

                      return result;
                    },
                    builder: (context, state) {
                      if (state is CreateAuctionIsLoading ||
                          state is AddUpdateAuctionIsLoading) {
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
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CommonButton(
                onPressed: () async {
                  // if (_formKey.currentState?.validate() ?? false) {
                  //   params = AddUpdateAuctionParams(
                  //     token: await secureStorage
                  //             .read(AppStrings.apiVerificationCode) ??
                  //         "",
                  //     customerID:
                  //         await secureStorage.read(AppStrings.customerId) ?? "",
                  //     auctionID: "0",
                  //     auctionCode: auctionCodeController.text,
                  //     auctionName: negotiationNameController.text,
                  //     deliveryAddress:
                  //         selectedLocationDelivery?.addressValue ?? "",
                  //     inspectionAgency: selectedInspectionAgency
                  //             ?.inspectionAgencyId
                  //             .toString() ??
                  //         "",
                  //     paymentTerm: selectedPaymentTerm,
                  //     bankerName: bankerNameAndAddressController.text,
                  //     currency: selectedCurrency?.currencyId.toString() ?? "",
                  //     partialDelivery: selectedPartialDelivery,
                  //     auctionStartDate: enquiryDate.toString(),
                  //     userTimeZone: Constants.timeZone,
                  //     totalQuantity: totalQuantityController.text,
                  //     minQuantity: minOrderQuantityController.text,
                  //     deliveryLastDate: dispatchDate.toString(),
                  //     agencyName: '',
                  //     agencyAddress: '',
                  //     agencyPhone: '',
                  //     agencyEmail: '',
                  //     remarks: deliveryTermsController.text,
                  //   );

                  //   await cubit.addUpdateAuction(params);
                  // }
                  Navigator.pushNamed(context, Routes.addProductScreen,
                      arguments: AddProductParams(
                          auctionID: "113325", groupID: widget.groupID));
                },
                text: "Create Negotiation",
                width: double.infinity,
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
