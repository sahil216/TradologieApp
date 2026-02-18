import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/negotiation_info_section.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/product_draft_card.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/widget/supplier_selector.dart';

import '../widget/expandable_section_card.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ExpandableController controller = ExpandableController();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: Constants.appBar(
        context,
        title: "Add Product for Negotiation",
        centerTitle: true,
      ),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          /// SECTION 0
          NegotiationInfoSection(
            index: 0,
            controller: controller,
            scrollController: scrollController,
          ),

          const SizedBox(height: 16),

          ProductDraftCard(
            index: 1,
            controller: controller,
            scrollController: scrollController,
          ),

          const SizedBox(height: 16),

          /// SECTION 1
          SupplierSelector(
            index: 2,
            controller: controller,
            scrollController: scrollController,
          ),
        ],
      ),
    );
  }
}
