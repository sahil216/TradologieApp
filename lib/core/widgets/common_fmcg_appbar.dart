import 'dart:ui';

import 'package:flutter/material.dart';

// /// A reusable fixed-height SliverAppBar matching the deep navy gradient design.
// /// The bar never collapses or expands — it stays the same height at all times.
// /// Includes optional search bar, filter button, back button, and action button.
// class CommonSliverAppBar extends StatefulWidget {
//   final String title;
//   final bool showBackButton;
//   final IconData? actionIcon;
//   final VoidCallback? onBackPressed;
//   final VoidCallback? onActionPressed;

//   const CommonSliverAppBar({
//     super.key,
//     required this.title,
//     this.showBackButton = false,
//     this.actionIcon,
//     this.onBackPressed,
//     this.onActionPressed,
//   });

//   @override
//   State<CommonSliverAppBar> createState() => _CommonSliverAppBarState();
// }

// class _CommonSliverAppBarState extends State<CommonSliverAppBar> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;

//     const double toolbarHeight = 56;

//     final double totalHeight = statusBarHeight + toolbarHeight;

//     return SliverAppBar(
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Color(0xFF064474),
//       automaticallyImplyLeading: false,
//       expandedHeight: 80,
//       flexibleSpace: LayoutBuilder(
//         builder: (context, constraints) {
//           final double topSafe = MediaQuery.of(context).padding.top;
//           final double min = kToolbarHeight;
//           final double percent =
//               ((constraints.maxHeight - min) / (80 - min)).clamp(0.0, 1.0);

//           final ease = Curves.easeOutQuart.transform(percent);
//           final scale = 0.88 + (ease * .12);
//           final blur = 14 + (1 - ease) * 10;

//           /// ⭐ MASTER BASELINE (EVERYTHING LOCKED HERE)
//           const double baseline = 8;

//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF042B4D), Color(0xFF064474)],
//                   ),
//                 ),
//                 child: SizedBox(
//                   height: toolbarHeight, // ✅ THIS IS THE FIX
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 40),
//                       Expanded(
//                         child: Center(
//                           // ✅ vertically center title
//                           child: Text(
//                             widget.title,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// ─── Gradient background — owns the full fixed bar layout ──────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const _SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.55),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.black.withValues(alpha: 0.6),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// ─── Filter button ──────────────────────────────────────────────────────────

class _FilterButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _FilterButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.tune_rounded, // sliders / filter icon
            color: Colors.black.withValues(alpha: 0.9),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final bool showFilter;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;

  SearchBarDelegate({
    required this.showFilter,
    this.onSearchChanged,
    this.onFilterPressed,
  });

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);

    /// 👇 Blur intensity (0 → 12)
    final blur = 0 + (progress * 24);

    /// 👇 Fade out search
    final opacity = 1 - progress;

    return SizedBox(
        height: maxExtent,
        child: Stack(fit: StackFit.expand, children: [
          /// 🌫️ BLUR BACKGROUND (Glass effect)
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                color: Color(0xFFF4F4F4), // fades in
              ),
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, -shrinkOffset),
              child: SizedBox.expand(
                child: Container(
                  decoration: const BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [Color(0xFF042B4D), Color(0xFF064474)],
                      // ),
                      ),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SearchField(
                          controller: TextEditingController(),
                          hint: 'Search',
                          onChanged: onSearchChanged,
                        ),
                      ),
                      if (showFilter) ...[
                        const SizedBox(width: 10),
                        _FilterButton(onPressed: onFilterPressed),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          )
        ]));
  }

  @override
  bool shouldRebuild(covariant SearchBarDelegate oldDelegate) => false;
}
