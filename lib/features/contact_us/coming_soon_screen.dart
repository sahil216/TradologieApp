import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';

class ComingSoonScreen extends StatefulWidget {
  final String title;
  final String description;

  const ComingSoonScreen({
    super.key,
    this.title = "Coming Soon",
    this.description =
        "This feature is under development and will be available soon.",
  });

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  @override
  void initState() {
    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenFade = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    );

    _screenScale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    _screenSlide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _screenController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdaptiveScaffold(
      body: FadeTransition(
        opacity: _screenFade,
        child: SlideTransition(
          position: _screenSlide,
          child: ScaleTransition(
            scale: _screenScale,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            widget.title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.description,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
