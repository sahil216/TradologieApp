import 'dart:async';

import 'package:flutter/material.dart';

class BuyerDashboardBannerEngine extends StatefulWidget {
  final List<AppBanner> banners;

  const BuyerDashboardBannerEngine({
    super.key,
    required this.banners,
  });

  @override
  State<BuyerDashboardBannerEngine> createState() =>
      _BuyerDashboardBannerEngineState();
}

class _BuyerDashboardBannerEngineState
    extends State<BuyerDashboardBannerEngine> {
  final PageController _controller = PageController(viewportFraction: 0.92);

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      _index++;
      if (_index >= widget.banners.length) {
        _index = 0;
      }

      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width * 0.55;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double page = 0;

                  if (_controller.hasClients &&
                      _controller.position.haveDimensions) {
                    page =
                        _controller.page ?? _controller.initialPage.toDouble();
                  }

                  /// PARALLAX SCALE EFFECT
                  final scale =
                      (1 - ((page - index).abs() * 0.08)).clamp(0.90, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: BuyerDashboardBannerCard(
                      banner: widget.banners[index],
                      pageOffset: (page - index),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        BuyerDashboardBannerIndicator(
          controller: _controller,
          count: widget.banners.length,
        ),
      ],
    );
  }
}

class AppBanner {
  final String image;
  final String title;
  final String subtitle;

  const AppBanner({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class BuyerDashboardBannerCard extends StatelessWidget {
  final AppBanner banner;
  final double pageOffset;

  const BuyerDashboardBannerCard({
    super.key,
    required this.banner,
    required this.pageOffset,
  });

  @override
  Widget build(BuildContext context) {
    /// PARALLAX IMAGE SHIFT
    final imageShift = pageOffset * 40;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(imageShift, 0),
              child: Image.network(
                banner.image,
                fit: BoxFit.cover,
              ),
            ),

            /// GLASS DARK OVERLAY
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.65),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),

            Positioned(
              left: 20,
              bottom: 22,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerDashboardBannerIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const BuyerDashboardBannerIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        double page = 0;
        if (controller.hasClients && controller.position.haveDimensions) {
          page = controller.page ?? 0;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (index) {
            final selectedness = (1 - (page - index).abs()).clamp(0.0, 1.0);

            final width = 8 + (18 * selectedness);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        );
      },
    );
  }
}
