import 'package:flutter/material.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/expandable_section_card.dart';

class ProductDraftCard extends StatelessWidget {
  final ExpandableController controller;
  final ScrollController scrollController;
  final int index;

  const ProductDraftCard({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableSectionCard(
      index: index,
      title: "Product Draft",
      controller: controller,
      scrollController: scrollController,
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              "https://images.unsplash.com/photo-1586201375761-83865001e31c",
              height: 110,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Basmati Rice",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text("1121 Raw Wand Rice"),
                  SizedBox(height: 6),
                  Text(
                    "Packing Type & Size: BOPP (5 KG)",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 6),
                  Text("Qty: 160"),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.delete_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
