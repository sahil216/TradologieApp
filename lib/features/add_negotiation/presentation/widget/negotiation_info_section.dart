import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/expandable_section_card.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/info_tile.dart';

class NegotiationInfoSection extends StatefulWidget {
  final ExpandableController controller;
  final ScrollController scrollController;
  final int index;

  const NegotiationInfoSection({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.index,
  });

  @override
  State<NegotiationInfoSection> createState() => _NegotiationInfoSectionState();
}

class _NegotiationInfoSectionState extends State<NegotiationInfoSection> {
  bool showProductForm = false;
  @override
  Widget build(BuildContext context) {
    return ExpandableSectionCard(
      index: widget.index,
      title: "Negotiation Details",
      controller: widget.controller,
      scrollController: widget.scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoTile(label: "Negotiation Name", value: "Onion"),
          const InfoTile(label: "Location of Delivery", value: "Mundra Port"),
          const InfoTile(label: "Payment Term", value: "LC"),
          const InfoTile(label: "Currency", value: "Euro (€)"),
          const InfoTile(label: "Status", value: "Draft"),
          const SizedBox(height: 8),
          CommonButton(
            text: "Add Product for Negotiation",
            onPressed: () {
              setState(() {
                showProductForm = !showProductForm;
              });
            },
          ),
          const SizedBox(height: 12),
          CommonButton(
            text: "Edit Negotiation",
            onPressed: () {},
          ),
          if (showProductForm) ...[
            const SizedBox(height: 16),
            _formField("Basmati Rice"),
            const SizedBox(height: 12),
            _formField("Select Grade"),
            const SizedBox(height: 12),
            _formField("Select Quality"),
            const SizedBox(height: 12),
            _formField("Select Product Type"),
            const SizedBox(height: 12),
            _formField("Enter Qty"),
            const SizedBox(height: 12),
            _formField("Per Sq. Ft."),
            const SizedBox(height: 12),
            _formField("Select Packing Type"),
            const SizedBox(height: 12),
            _formField("Select Packing Size"),
            const SizedBox(height: 12),
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
                // const Text("No image chosen"),
              ],
            ),
            const SizedBox(height: 12),
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
            CommonButton(
              text: "Submit",
              onPressed: () {},
            ),
          ],
        ],
      ),
    );
  }

  Widget _formField(String hint) {
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
}
