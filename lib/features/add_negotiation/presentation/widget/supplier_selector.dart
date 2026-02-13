import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/expandable_section_card.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/selectable_circle_widget.dart';

class SupplierSelector extends StatefulWidget {
  final ExpandableController controller;
  final ScrollController scrollController;
  final int index;

  const SupplierSelector({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.index,
  });

  @override
  State<SupplierSelector> createState() => _SupplierSelectorState();
}

class _SupplierSelectorState extends State<SupplierSelector> {
  final suppliers = [
    "59c Expo Haryana India",
    "Mishtann Foods Limited Gujarat India",
    "Nazir & Sons Commodities Rice Mill Pakistan",
  ];

  final selected = <int>{};

  @override
  Widget build(BuildContext context) {
    return ExpandableSectionCard(
      index: widget.index,
      title: "Choose Supplier for Negotiation",
      controller: widget.controller,
      scrollController: widget.scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SEARCH
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xffF2F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                icon: Icon(Icons.search),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// SUPPLIER LIST
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suppliers.length,
            itemBuilder: (_, i) {
              final isSelected = selected.contains(i);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: AnimatedSelectableCircle(
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected ? selected.remove(i) : selected.add(i);
                    });
                  },
                ),
                title: Text(suppliers[i]),
              );
            },
          ),

          const SizedBox(height: 16),

          CommonButton(
            text: "Submit Negotiation",
            onPressed: () {},
          ),

          const SizedBox(height: 12),

          CommonButton(
            text: "Clear all",
            onPressed: () => setState(selected.clear),
          ),
        ],
      ),
    );
  }
}
