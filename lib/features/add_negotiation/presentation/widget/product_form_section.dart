import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/expandable_section_card.dart';

class ProductFormSection extends StatelessWidget {
  final ExpandableController controller;
  final ScrollController scrollController;
  final int index;

  const ProductFormSection({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.index,
  });

  Widget _field(String hint) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xffF4F6F9),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        hint,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableSectionCard(
      index: index,
      title: "Add Product",
      controller: controller,
      scrollController: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CATEGORY
          _field("Basmati Rice"),
          const SizedBox(height: 12),

          /// GRADE
          _field("Select Grade"),
          const SizedBox(height: 12),

          /// QUALITY
          _field("Select Quality"),
          const SizedBox(height: 12),

          /// PRODUCT TYPE
          _field("Select Product Type"),
          const SizedBox(height: 12),

          /// QTY
          _field("Enter Qty"),
          const SizedBox(height: 12),

          /// UNIT
          _field("Per Sq. Ft."),
          const SizedBox(height: 12),

          /// PACKING TYPE
          _field("Select Packing Type"),
          const SizedBox(height: 12),

          /// PACKING SIZE
          _field("Select Packing Size"),
          const SizedBox(height: 12),

          /// UPLOAD IMAGE BUTTON
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xff2F80ED),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Upload Packing Image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              const Text("No image chosen"),
            ],
          ),

          const SizedBox(height: 12),

          /// OTHER SPECIFICATIONS
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffF4F6F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Please enter Other Specifications. If any.",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 16),

          /// SUBMIT BUTTON
          CommonButton(
            text: "Submit",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
