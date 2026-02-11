import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text_field.dart';
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
  const AddNegotiationDetailsScreen({super.key});

  @override
  State<AddNegotiationDetailsScreen> createState() =>
      _AddNegotiationDetailsScreenState();
}

class _AddNegotiationDetailsScreenState
    extends State<AddNegotiationDetailsScreen> {
  List<CommodityList>? categoryList;

  CommodityList? selectedCommodity;

  DateTime? enquiryDate;
  DateTime? dispatchDate;

  SecureStorageService secureStorage = SecureStorageService();

  Key categoryKey = UniqueKey();

  final _formKey = GlobalKey<FormState>();

  List<CommodityList> fetchCommodity(String filter, LoadProps? loadProps) {
    final allItems = categoryList ?? [];
    if (filter.isEmpty) return allItems;
    return allItems
        .where((e) =>
            (e.groupName ?? "").toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  final dropDownKey = GlobalKey<DropdownSearchState>();

  AddNegotiationCubit get cubit =>
      BlocProvider.of<AddNegotiationCubit>(context);

  Future<void> getCategory() async {
    await cubit.getCategoryList(NoParams());
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
            if (state is GetCategorySuccess) {
              categoryList = state.data;
            }
            if (state is GetCategoryError) {
              Constants.showFailureToast(state.failure);
            }
            if (state is GetSupplierListSuccess) {
              setState(() {
                // supplierList = state.data;
              });
            }
            if (state is GetSupplierListError) {
              Constants.showFailureToast(state.failure);
            }
            if (state is GetSupplierShortistedSuccess) {
              setState(() {
                // shortlistedSupplierList = state.data;
              });
            }
            if (state is GetSupplierShortistedError) {
              Constants.showFailureToast(state.failure);
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
            buildWhen: (previous, current) {
              bool result = previous != current;
              result = result &&
                  (current is GetDashboardSuccess ||
                      current is GetDashboardError ||
                      current is GetDashboardIsLoading);
              return result;
            },
            builder: (context, state) {
              if (state is GetCategoryError) {
                if (state.failure is NetworkFailure) {
                  return CustomErrorNetworkWidget(
                    onPress: () {
                      getCategory();
                    },
                  );
                } else if (state.failure is UserFailure) {
                  return CustomErrorWidget(
                    onPress: () {
                      getCategory();
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
                            CommonTextField(
                              titleText: "Negotiation Reference Code",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Negotiation Reference Code",
                              textRequired: "Enter Negotiation Reference Code",
                              controller: TextEditingController(),
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [],
                              isEnable: true,
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
                            CommonTextField(
                              titleText: "Negotiation Name",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Negotiation Name",
                              textRequired: "Enter Negotiation Name",
                              controller: TextEditingController(),
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [],
                              isEnable: true,
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
                            CommonDropdown<CommodityList>(
                              label: 'Inspection Agency ',
                              hint: 'Select Inspection Agency',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchCommodity(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.groupName ?? "",
                              onChanged: (item) async {},
                              compareFn: (a, b) => a.groupName == b.groupName,
                            ),
                            CommonDropdown<CommodityList>(
                              label: 'Location of Delivery',
                              hint: 'Select Location of Delivery',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchCommodity(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.groupName ?? "",
                              onChanged: (item) async {},
                              compareFn: (a, b) => a.groupName == b.groupName,
                            ),
                            CommonTextField(
                              titleText: "State of Delivery",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter State of Delivery",
                              textRequired: "Enter State of Delivery",
                              controller: TextEditingController(),
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [],
                              isEnable: true,
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
                            CommonTextField(
                              titleText: "Port of Discharge",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Port of Discharge",
                              textRequired: "Enter Port of Discharge",
                              controller: TextEditingController(),
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [],
                              isEnable: true,
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
                            CommonDropdown<CommodityList>(
                              label: 'Payment Term',
                              hint: 'Select Payment Term',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchCommodity(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.groupName ?? "",
                              onChanged: (item) async {},
                              compareFn: (a, b) => a.groupName == b.groupName,
                            ),
                            CommonDropdown<CommodityList>(
                              label: 'Cuurency',
                              hint: 'Select Cuurency',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchCommodity(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.groupName ?? "",
                              onChanged: (item) async {},
                              compareFn: (a, b) => a.groupName == b.groupName,
                            ),
                            CommonDropdown<CommodityList>(
                              label: 'Partial Delivery',
                              hint: 'Select Partial Delivery',
                              dropdownKey: categoryKey,
                              asyncItems: (filter, loadProps) {
                                return fetchCommodity(filter, loadProps);
                              },
                              validator: (value) =>
                                  value == null ? "Required" : null,
                              selectedItem: null,
                              itemAsString: (item) => item.groupName ?? "",
                              onChanged: (item) async {},
                              compareFn: (a, b) => a.groupName == b.groupName,
                            ),
                            CommonCupertinoDatePicker(
                              label:
                                  "Preferred Date and Time of Enquiry (yyyy/mm/dd HH:mm)",
                              hint: "Select Date and Time of Enquiry",
                              selectedDate: enquiryDate,
                              mode: CupertinoDatePickerMode.dateAndTime,
                              dateFormat: DateFormat("yyyy/MM/dd HH:mm"),
                              minimumDate: DateTime.now(),
                              onDateSelected: (date) {
                                setState(() {
                                  enquiryDate = date;
                                });
                              },
                            ),
                            CommonTextField(
                              titleText: "Total quantity",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Total quantity",
                              textRequired: "Enter Total quantity",
                              controller: TextEditingController(),
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [],
                              isEnable: true,
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
                            CommonTextField(
                              titleText: "Min order quantity per supplier",
                              titleStyle: TextStyleConstants.semiBold(context),
                              hintText: "Enter Min order quantityper supplier",
                              textRequired:
                                  "Enter Min order quantityper supplier",
                              controller: TextEditingController(),
                              backgroundColor: AppColors.transparent,
                              textInputType: TextInputType.number,
                              inputFormatters: [],
                              isEnable: true,
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
                            CommonCupertinoDatePicker(
                              label: "Last Date of Dispatch (yyyy/mm/dd)",
                              hint: "Enter last date of dispatch",
                              selectedDate: dispatchDate,
                              mode: CupertinoDatePickerMode.date,
                              dateFormat: DateFormat("yyyy/MM/dd"),
                              minimumDate: DateTime.now(),
                              onDateSelected: (date) {
                                setState(() {
                                  dispatchDate = date;
                                });
                              },
                            ),
                            CommonTextField(
                              titleText: "Delivery Terms",
                              hintText: "Enter Delivery Terms",
                              titleStyle: TextStyleConstants.semiBold(context),
                              textRequired: "Enter Delivery Terms",
                              controller: TextEditingController(),
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
                            SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: CommonButton(
                                  onPressed: () {},
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
                          (current is GetCategoryIsLoading ||
                              current is GetCategorySuccess ||
                              current is GetCategoryError ||
                              current is GetSupplierListIsLoading ||
                              current is GetSupplierListSuccess ||
                              current is GetSupplierListError ||
                              current is AddSupplierShortlistIsLoading ||
                              current is AddSupplierShortlistSuccess ||
                              current is AddSupplierShortlistError ||
                              current is DeleteSupplierShortlistIsLoading ||
                              current is DeleteSupplierShortlistSuccess ||
                              current is DeleteSupplierShortlistError ||
                              current is GetSupplierShortistedIsLoading ||
                              current is GetSupplierShortistedSuccess ||
                              current is GetSupplierShortistedError);

                      return result;
                    },
                    builder: (context, state) {
                      if (state is GetCategoryIsLoading ||
                          state is GetSupplierListIsLoading ||
                          state is AddSupplierShortlistIsLoading ||
                          state is DeleteSupplierShortlistIsLoading ||
                          state is GetSupplierShortistedIsLoading) {
                        return const CommonLoader();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
