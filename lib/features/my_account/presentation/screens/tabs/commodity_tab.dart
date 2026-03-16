import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class CommodityTab extends StatefulWidget {
  const CommodityTab({super.key});

  @override
  State<CommodityTab> createState() => _CommodityTabState();
}

class _CommodityTabState extends State<CommodityTab>
    with SingleTickerProviderStateMixin {
  bool? data = false;

  String? selectedProduct;

  final List<Map<String, String>> products = [
    {"product": "Wheat", "type": "-", "subType": "-"},
    {"product": "Basmati", "type": "-", "subType": "-"},
    {"product": "Non Basmati", "type": "-", "subType": "-"},
    {"product": "Oil", "type": "-", "subType": "-"},
    {"product": "Meat", "type": "-", "subType": "-"},
    {"product": "Onion", "type": "-", "subType": "-"},
    {"product": "Sugar Domestic", "type": "-", "subType": "-"},
    {"product": "Spice", "type": "-", "subType": "-"},
    {"product": "Dairy", "type": "-", "subType": "-"},
    {"product": "Pulses", "type": "-", "subType": "-"},
    {"product": "Cashew", "type": "-", "subType": "-"},
    {"product": "Fox Nuts (Makhana)", "type": "-", "subType": "-"},
    {
      "product": "16 mm x 8 ft x 4 ft Ecotec Green MR Grade ply",
      "type": "-",
      "subType": "-"
    },
    {
      "product": "7FT X 4FT GREENPLY GOLD",
      "type": "8'x3'x4mm Ply",
      "subType": "Flushdoor"
    },
  ];

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getCommodity() {}

  @override
  void initState() {
    super.initState();
    getCommodity();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is CommoditySuccess) {
              data = state.data;
            }
            if (state is CommodityError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is CommoditySuccess ||
                  current is CommodityError ||
                  current is CommodityIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is CommodityError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getCommodity();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getCommodity();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return CustomScrollView(slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedProduct,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      hint: const Text("-- Select Product --"),
                      items: products
                          .map((e) => DropdownMenuItem(
                                value: e["product"],
                                child: Text(e["product"]!),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedProduct = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Divider
            SliverToBoxAdapter(
              child: Container(
                height: 8,
                color: Colors.grey.shade200,
              ),
            ),

            /// List Header
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.grey.shade300,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 3, child: Text("Product")),
                    Expanded(flex: 2, child: Text("Type")),
                    Expanded(flex: 2, child: Text("SubType")),
                  ],
                ),
              ),
            ),

            /// Product List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = products[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(item["product"]!),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(item["type"]!),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(item["subType"]!),
                        ),
                      ],
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ]);
        },
      ),
    );
  }
}
