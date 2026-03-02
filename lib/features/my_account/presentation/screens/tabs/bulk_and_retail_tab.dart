import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../../core/error/network_failure.dart';
import '../../../../../core/error/user_failure.dart';
import '../../../../../core/widgets/common_loader.dart';
import '../../../../../core/widgets/custom_error_network_widget.dart';
import '../../../../../core/widgets/custom_error_widget.dart';

class BulkAndRetailTab extends StatefulWidget {
  const BulkAndRetailTab({super.key});

  @override
  State<BulkAndRetailTab> createState() => _BulkAndRetailTabState();
}

class _BulkAndRetailTabState extends State<BulkAndRetailTab>
    with SingleTickerProviderStateMixin {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getBulkRetail() {}
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  @override
  void initState() {
    super.initState();
    getBulkRetail();
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

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  bool bidding = true;
  bool enabled = true;

  List<Map<String, dynamic>> records = []; // Empty → No Record Found

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is BulkRetailSuccess) {
              data = state.data;
            }
            if (state is BulkRetailError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is BulkRetailSuccess ||
                  current is BulkRetailError ||
                  current is BulkRetailIsLoading);
          return result;
        },
        builder: (context, state) {
          if (data == null) {
            if (state is BulkRetailError) {
              if (state.failure is NetworkFailure) {
                return CustomErrorNetworkWidget(
                  onPress: () {
                    getBulkRetail();
                  },
                );
              } else if (state.failure is UserFailure) {
                return CustomErrorWidget(
                  onPress: () {
                    getBulkRetail();
                  },
                  errorText: state.failure.msg,
                );
              }
            }
            return const CommonLoader();
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Group"),
                      const SizedBox(height: 6),
                      _dropdown(),
                      const SizedBox(height: 16),
                      _label("Retail Min Quantity"),
                      _textField(),
                      const SizedBox(height: 16),
                      _label("Retail Max Quantity"),
                      _textField(),
                      const SizedBox(height: 16),
                      _label("Bulk Min Quantity"),
                      _textField(),
                      const SizedBox(height: 16),
                      _label("Bulk Max Quantity"),
                      _textField(),
                      const SizedBox(height: 16),
                      _label("Priority"),
                      _textField(),
                      const SizedBox(height: 20),
                      _label("Bidding"),
                      const SizedBox(height: 8),
                      _yesNoToggle(
                        value: bidding,
                        onChanged: (val) => setState(() => bidding = val),
                      ),
                      const SizedBox(height: 20),
                      _label("Enabled"),
                      const SizedBox(height: 8),
                      _yesNoToggle(
                        value: enabled,
                        onChanged: (val) => setState(() => enabled = val),
                      ),
                      const SizedBox(height: 24),
                      _submitButton(),
                      const SizedBox(height: 30),
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

              /// Records Section
              records.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "No Record Found...!",
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _recordCard(index, records[index]),
                          childCount: records.length,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  /// TextField
  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Dropdown
  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      hint: const Text("---Select Group---"),
      items: const [
        DropdownMenuItem(value: "1", child: Text("Group 1")),
        DropdownMenuItem(value: "2", child: Text("Group 2")),
      ],
      onChanged: (val) {},
    );
  }

  /// Yes / No Toggle
  Widget _yesNoToggle({
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: value ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Yes",
                style: TextStyle(
                  color: value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !value ? Colors.grey : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "No",
                style: TextStyle(
                  color: !value ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Submit Button
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: const Text("Submit"),
      ),
    );
  }

  /// Record Card (Mobile version of complex table)
  Widget _recordCard(int index, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("S.No: ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Group: ${data["group"]}"),
            Text("Retail: ${data["retailMin"]} - ${data["retailMax"]}"),
            Text("Bulk: ${data["bulkMin"]} - ${data["bulkMax"]}"),
            Text("Priority: ${data["priority"]}"),
            Text("Bidding: ${data["bidding"] ? "Yes" : "No"}"),
            Text("Active: ${data["enabled"] ? "Yes" : "No"}"),
          ],
        ),
      ),
    );
  }
}
