import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/cubit/add_negotiation_cubit.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/supplier_card.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';

import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../domian/usecases/get_supplier_list_usecase.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List<CommodityList>? categoryList;

  List<SupplierList>? supplierList;
  List<SupplierList>? shortlistedSupplierList;

  CommodityList? selectedCommodity;

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
    getCategory();
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
                supplierList = state.data;
              });
            }
            if (state is GetSupplierListError) {
              Constants.showFailureToast(state.failure);
            }
            if (state is GetSupplierShortistedSuccess) {
              setState(() {
                shortlistedSupplierList = state.data;
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
                      child: Column(
                        children: [
                          /// 🔒 FIXED TOP
                          CommonDropdown<CommodityList>(
                            label: 'Category *',
                            hint: 'Select Category',
                            dropdownKey: categoryKey,
                            asyncItems: (filter, loadProps) {
                              return fetchCommodity(filter, loadProps);
                            },
                            validator: (value) =>
                                value == null ? "Required" : null,
                            selectedItem: null,
                            itemAsString: (item) => item.groupName ?? "",
                            onChanged: (item) async {
                              SecureStorageService secureStorage =
                                  SecureStorageService();

                              final params = SupplierListParams(
                                customerId: await secureStorage
                                        .read(AppStrings.customerId) ??
                                    "",
                                groupID: item?.groupId ?? "",
                              );

                              selectedCommodity = item;

                              supplierList?.clear();
                              cubit.getSupplierList(params);
                              cubit.getSupplierShortlisted(params);
                              setState(() {});
                            },
                            compareFn: (a, b) => a.groupName == b.groupName,
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

                          /// 🟦 SCROLLABLE LIST (ONLY THIS SCROLLS)
                          Expanded(
                            child: supplierList == null
                                ? const SizedBox.shrink()
                                : ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    itemCount: supplierList?.length ?? 0,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final item = supplierList![index];
                                      return SupplierInfoCard(
                                        supplier: item,
                                        addRemoveShortListButton: cubit
                                                .isSupplierShortlisted(
                                                    supplier: item,
                                                    shortlisted:
                                                        shortlistedSupplierList)
                                            ? () async {
                                                late RemoveSupplierShortlistParams
                                                    params;

                                                params =
                                                    RemoveSupplierShortlistParams(
                                                  token: await secureStorage
                                                          .read(AppStrings
                                                              .apiVerificationCode) ??
                                                      "",
                                                  shortlistID: item.shortlistId
                                                      .toString(),
                                                );

                                                cubit.deleteSupplierShortlist(
                                                    params);
                                              }
                                            : () {},
                                        isShortlisted:
                                            cubit.isSupplierShortlisted(
                                                supplier: item,
                                                shortlisted:
                                                    shortlistedSupplierList),
                                      );
                                    },
                                  ),
                          ),
                        ],
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
