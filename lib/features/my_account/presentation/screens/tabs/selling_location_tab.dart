import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

class SellingLocationTab extends StatefulWidget {
  const SellingLocationTab({super.key});

  @override
  State<SellingLocationTab> createState() => _SellingLocationTabState();
}

class _SellingLocationTabState extends State<SellingLocationTab>
    with SingleTickerProviderStateMixin {
  bool? data = false;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  void getSellingLocation() {}

  String? selectedState;
  String? selectedCity;

  final List<Map<String, dynamic>> locations = [
    {"state": "Abu Dhabi", "city": "All City"},
    {"state": "Alexandria", "city": "Ein El Sokhna"},
    {"state": "Delhi", "city": "Ghaziabad"},
    {"state": "ISTANBUL", "city": "Izmir"},
    {"state": "Jebel Ali", "city": "Jebel Ali Port"},
    {"state": "Uttar Pradesh", "city": "Mahura"},
    {"state": "WESTERN CAPE", "city": "CAPE TOWN"},
  ];

  @override
  void initState() {
    super.initState();
    getSellingLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MyAccountCubit, MyAccountState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is SellingLocationSuccess) {
              data = state.data;
            }
            if (state is SellingLocationError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: BlocBuilder<MyAccountCubit, MyAccountState>(
        buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is SellingLocationSuccess ||
                  current is SellingLocationError ||
                  current is SellingLocationIsLoading);
          return result;
        },
        builder: (context, state) {
          return CustomScrollView(slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("State/Province"),
                    const SizedBox(height: 6),
                    _dropdown(
                      hint: "--Select State--",
                      value: selectedState,
                      onChanged: (val) => setState(() => selectedState = val),
                    ),
                    const SizedBox(height: 16),
                    _label("City"),
                    const SizedBox(height: 6),
                    _dropdown(
                      hint: "--Select City--",
                      value: selectedCity,
                      onChanged: (val) => setState(() => selectedCity = val),
                    ),
                    const SizedBox(height: 20),
                    _submitButton(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 8,
                color: Colors.grey.shade200,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _locationCard(index, locations[index]),
                  childCount: locations.length,
                ),
              ),
            ),
          ]);
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

  /// Dropdown
  Widget _dropdown({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      hint: Text(hint),
      items: const [
        DropdownMenuItem(value: "1", child: Text("Option 1")),
        DropdownMenuItem(value: "2", child: Text("Option 2")),
      ],
      onChanged: onChanged,
    );
  }

  /// Submit Button
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
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

  /// Card instead of Table (Mobile Optimized)
  Widget _locationCard(int index, Map<String, dynamic> data) {
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
            /// Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "S.No: ${index + 1}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),

            Text("State: ${data["state"]}"),
            const SizedBox(height: 4),
            Text("City: ${data["city"]}"),
            const SizedBox(height: 8),

            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text("Active"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
