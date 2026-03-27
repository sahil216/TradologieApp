import 'package:flutter/material.dart';

/// A reusable fixed-height SliverAppBar matching the deep navy gradient design.
/// The bar never collapses or expands — it stays the same height at all times.
/// Includes optional search bar, filter button, back button, and action button.
class CommonSliverAppBar extends StatefulWidget {
  final String title;
  final bool showSearch;
  final bool showFilter;
  final bool showBackButton;
  final IconData? actionIcon;
  final VoidCallback? onBackPressed;
  final VoidCallback? onActionPressed;
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;

  const CommonSliverAppBar({
    super.key,
    required this.title,
    this.showSearch = false,
    this.showFilter = false,
    this.showBackButton = false,
    this.actionIcon,
    this.onBackPressed,
    this.onActionPressed,
    this.onFilterPressed,
    this.onSearchChanged,
    this.searchHint = 'Search',
  });

  @override
  State<CommonSliverAppBar> createState() => _CommonSliverAppBarState();
}

class _CommonSliverAppBarState extends State<CommonSliverAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Compute the fixed total height:
    //   status-bar + toolbar (56) + search row (44) + vertical padding (32)
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double fixedHeight = statusBarHeight + (widget.showSearch ? 48 : 0);

    return SliverAppBar(
      // ── Key settings that lock the height ────────────────────────────────
      expandedHeight: fixedHeight,
      collapsedHeight: fixedHeight, // same as expanded → never collapses
      pinned: true,
      floating: false,
      snap: false,
      stretch: false, // no over-scroll stretch
      elevation: 5,
      toolbarHeight: fixedHeight, // keeps the SliverAppBar from shrinking
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,

      // ── FlexibleSpaceBar fills the fixed area ────────────────────────────
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none, // disables all collapse animation
        background: _AppBarBackground(
          title: widget.title,
          showSearch: widget.showSearch,
          showFilter: widget.showFilter,
          showBackButton: widget.showBackButton,
          actionIcon: widget.actionIcon,
          searchController: _searchController,
          searchHint: widget.searchHint,
          onSearchChanged: widget.onSearchChanged,
          onFilterPressed: widget.onFilterPressed,
          onBackPressed:
              widget.onBackPressed ?? () => Navigator.of(context).maybePop(),
          onActionPressed: widget.onActionPressed,
        ),
      ),
    );
  }
}

// ─── Gradient background — owns the full fixed bar layout ──────────────────

class _AppBarBackground extends StatelessWidget {
  final String title;
  final bool showSearch;
  final bool showFilter;
  final bool showBackButton;
  final IconData? actionIcon;
  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onBackPressed;
  final VoidCallback? onActionPressed;

  const _AppBarBackground({
    required this.title,
    required this.showSearch,
    required this.showFilter,
    required this.showBackButton,
    required this.actionIcon,
    required this.searchController,
    required this.searchHint,
    required this.onBackPressed,
    this.onSearchChanged,
    this.onFilterPressed,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF042B4D),
            Color(0xFF064474),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Top row: back | title | action ────────────────────────
              Row(
                children: [
                  // Back button (fixed 40 px slot so title is always centred)
                  SizedBox(
                    width: 40,
                    child: showBackButton
                        ? _NavButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onPressed: onBackPressed,
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Title — centred between the two fixed slots
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Action button (fixed 40 px slot)
                  SizedBox(
                    width: 40,
                    child: actionIcon != null
                        ? _NavButton(
                            icon: actionIcon!,
                            onPressed: onActionPressed,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),

              // ── Search + filter row ────────────────────────────────────
              if (showSearch) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SearchField(
                        controller: searchController,
                        hint: searchHint,
                        onChanged: onSearchChanged,
                      ),
                    ),
                    if (showFilter) ...[
                      const SizedBox(width: 10),
                      _FilterButton(onPressed: onFilterPressed),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Search field ───────────────────────────────────────────────────────────

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
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.6),
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
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.tune_rounded, // sliders / filter icon
            color: Colors.white.withValues(alpha: 0.9),
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─── Nav button (back / action) ─────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ─── Demo / Usage example ───────────────────────────────────────────────────

class DistributorsInquiryPage extends StatelessWidget {
  const DistributorsInquiryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // ── Drop-in usage ──────────────────────────────────────────────
          CommonSliverAppBar(
            title: 'Distributors Inquiry',
            showSearch: true,
            showFilter: true,
            showBackButton: true,
            actionIcon: Icons.more_vert_rounded, // trailing icon
            onBackPressed: () => Navigator.of(context).maybePop(),
            onActionPressed: () {
              // handle trailing action
            },
            onFilterPressed: () {
              // open filter sheet
            },
            onSearchChanged: (query) {
              // handle search
            },
          ),

          // ── Content ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _DemoCard(index: index),
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  final int index;
  const _DemoCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Color(0xFF1565C0),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distributor ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF0D2B5E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Region ${index % 5 + 1} • Active',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
