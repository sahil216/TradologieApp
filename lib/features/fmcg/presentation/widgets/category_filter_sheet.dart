import 'package:flutter/material.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_category_list.dart';

class CategoryFilterSheet extends StatefulWidget {
  final Set<String> selectedCategories;
  final Function(Set<String>) onApply;
  final List<FmcgBuyerCategoryList> categories;

  const CategoryFilterSheet({
    super.key,
    required this.selectedCategories,
    required this.onApply,
    required this.categories,
  });

  @override
  State<CategoryFilterSheet> createState() => _CategoryFilterSheetState();
}

class _CategoryFilterSheetState extends State<CategoryFilterSheet> {
  late Set<String> selected;

  @override
  void initState() {
    selected = {...widget.selectedCategories};
    super.initState();
  }

  void toggle(String cat) {
    setState(() {
      if (selected.contains(cat)) {
        selected.remove(cat);
      } else {
        selected.add(cat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Close
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
              ),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Title + Clear
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Select Category",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (selected.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => selected.clear()),
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                      color: Color(0xFF0A9FED),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          /// Chips
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: widget.categories.map((cat) {
              final isSelected = selected.contains(cat.name ?? "");

              return GestureDetector(
                onTap: () => toggle(cat.name ?? ""),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0A9FED)
                        : const Color(0xFFF2F7FB),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF0A9FED).withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child:
                              Icon(Icons.check, size: 14, color: Colors.white),
                        ),
                      Text(
                        cat.name ?? "",
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF0A6EBE),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          /// Apply
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () {
                widget.onApply(selected);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2DAAE1),
                      Color(0xFF1B8ED1),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Apply (${selected.length})",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
