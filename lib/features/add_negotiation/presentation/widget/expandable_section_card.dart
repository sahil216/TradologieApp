import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';

class ExpandableSectionCard extends StatelessWidget {
  final int index;
  final String title;
  final Widget child;
  final ExpandableController controller;
  final ScrollController scrollController;

  const ExpandableSectionCard({
    super.key,
    required this.index,
    required this.title,
    required this.child,
    required this.controller,
    required this.scrollController,
  });

  void _handleTap(BuildContext context) {
    controller.toggle(index);

    /// ⭐ AUTO SCROLL TO OPENED SECTION (Premium UX)
    if (controller.isOpen(index)) {
      Future.delayed(const Duration(milliseconds: 260), () {
        final ctx = context;
        if (!ctx.mounted) return;
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: .05,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final expanded = controller.isOpen(index);

        return RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: expanded ? 14 : 8,
                  offset: const Offset(0, 6),
                  color: Colors.black.withValues(alpha: .06),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _handleTap(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonText(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 280),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),

                /// DIVIDER
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: expanded ? 1 : 0,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: Divider(height: 1),
                  ),
                ),

                /// BODY (Ultra Smooth)
                ClipRect(
                  child: AnimatedAlign(
                    alignment: Alignment.topCenter,
                    heightFactor: expanded ? 1 : 0,
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExpandableController extends ChangeNotifier {
  final Set<int> _openedIndexes;

  ExpandableController({Set<int>? defaultOpened})
      : _openedIndexes = defaultOpened ?? {};

  Set<int> get openedIndexes => _openedIndexes;

  void toggle(int index) {
    if (_openedIndexes.contains(index)) {
      _openedIndexes.remove(index);
    } else {
      _openedIndexes.add(index);
    }
    notifyListeners();
  }

  bool isOpen(int index) => _openedIndexes.contains(index);
}
