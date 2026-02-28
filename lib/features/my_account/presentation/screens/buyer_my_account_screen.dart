import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_banner_engine.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_dashboard_cards.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import '../../../../injection_container.dart';

class BuyerMyAccountScreen extends StatefulWidget {
  const BuyerMyAccountScreen({super.key});

  @override
  State<BuyerMyAccountScreen> createState() => _BuyerMyAccountScreenState();
}

class _BuyerMyAccountScreenState extends State<BuyerMyAccountScreen>
    with SingleTickerProviderStateMixin {
  MyAccountCubit get myAccountCubit => BlocProvider.of<MyAccountCubit>(context);

  final ScrollController _scrollController = ScrollController();

  final ScrollController _scroll = ScrollController();
  double depth = 0;
  double pointerX = 0;
  double pointerY = 0;

  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  int index = 0;
  @override
  void initState() {
    super.initState();

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

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _screenController.forward();
    });
  }

  bool isEditing = false;

  final nameController = TextEditingController(text: "TRD(DEMO)");
  final mobileController = TextEditingController(text: "7303384866");
  final companyController = TextEditingController(text: "tradologie.com");
  final categoryController = TextEditingController(text: "Non Basmati");
  @override
  void dispose() {
    _screenController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocBuilder<MyAccountCubit, MyAccountState>(
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Listener(
                  onPointerMove: (e) {
                    final size = MediaQuery.of(context).size;
                    setState(() {
                      pointerX = ((e.position.dx / size.width) - .5) * 2;
                      pointerY = ((e.position.dy / size.height) - .5) * 2;
                    });
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scroll) {
                      final velocity = scroll is ScrollUpdateNotification
                          ? scroll.scrollDelta ?? 0
                          : 0;
                      setState(() {
                        depth = (velocity / 30).clamp(-1.0, 1.0);
                      });
                      return false;
                    },
                    child: FadeTransition(
                      opacity: _screenFade,
                      child: SlideTransition(
                        position: _screenSlide,
                        child: ScaleTransition(
                          scale: _screenScale,
                          child: CustomScrollView(
                            controller: _scroll,
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            slivers: [
                              /// ✅ Your Sliver AppBar (assuming CommonAppbar returns a SliverAppBar)
                              CommonAppbar(
                                title: "My Account",
                                showBackButton: false,
                                showNotification: true,
                              ),

                              /// 🧊 Glass Blur Background Section (give it height)

                              /// 🪐 Profile Section (FIXED — wrapped properly)
                              SliverToBoxAdapter(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Transform.translate(
                                    offset: const Offset(
                                        0, 0), // float over blur section
                                    child: Column(
                                      children: [
                                        Hero(
                                          tag: "profile",
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              color: Colors.white
                                                  .withOpacity(0.45),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                              ),
                                              boxShadow: [
                                                /// Upper highlight
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  offset: const Offset(0, -3),
                                                  blurRadius: 10,
                                                ),

                                                /// Ambient depth
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.07),
                                                  offset: const Offset(0, 20),
                                                  blurRadius: 40,
                                                  spreadRadius: -10,
                                                ),

                                                /// Micro depth
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.04),
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 12,
                                                ),
                                              ],
                                            ),
                                            child: const CircleAvatar(
                                              radius: 55,
                                              backgroundImage: NetworkImage(
                                                "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          "TRD (DEMO)",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// 💎 Account Info

                              SliverToBoxAdapter(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LuxurySectionTitle(
                                        title: "Account Information"),
                                    TextButton.icon(
                                      onPressed: () {
                                        sl<NavigationService>().pushNamed(
                                            Routes.editAccountScreen);
                                      },
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text("Edit"),
                                    ),
                                  ],
                                ),
                              ),

                              SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                sliver: SliverToBoxAdapter(
                                  child: GlassCard(
                                    child: Column(
                                      children: const [
                                        _LuxuryRow("Mobile No", "7303384866"),
                                        _GlassDivider(),
                                        _LuxuryRow("Company", "tradologie.com"),
                                        _GlassDivider(),
                                        _LuxuryRow("Category", "Non Basmati"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// 📍 Address Section
                              SliverToBoxAdapter(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LuxurySectionTitle(title: "Addresses"),
                                    TextButton.icon(
                                      onPressed: () {
                                        sl<NavigationService>()
                                            .pushNamed(Routes.addAddressScreen);
                                      },
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text("Add Address"),
                                    ),
                                  ],
                                ),
                              ),

                              SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      _GlassAddressCard(
                                        address:
                                            "Mundra Port, MUNDRA PORT, Mundra Port, Uttar Pradesh, India - 370201",
                                      ),
                                      const SizedBox(height: 16),
                                      _GlassAddressCard(
                                        address:
                                            "CIF - SALALAH PORT OMAN, SALALAH PORT OMAN, Uttar Pradesh, India",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    LuxurySectionTitle(
                                        title: "Enquiry Notifications"),
                                    TextButton.icon(
                                      onPressed: () {
                                        sl<NavigationService>().pushNamed(
                                            Routes.supplierListScreen);
                                      },
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text("Add Negotiation"),
                                    ),
                                  ],
                                ),
                              ),

                              SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 24, 20, 0),
                                  child: _EnquiryNotificationSection(),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(height: 70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔹 SECTION HEADER
}

class LuxurySectionTitle extends StatelessWidget {
  final String title;
  const LuxurySectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 14),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: Colors.black54,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🧊 Glass Card
////////////////////////////////////////////////////////////

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.35),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 💎 Info Row
////////////////////////////////////////////////////////////

class _LuxuryRow extends StatelessWidget {
  final String title;
  final String value;
  const _LuxuryRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54)),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}

class _GlassDivider extends StatelessWidget {
  const _GlassDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white.withOpacity(0.6),
      height: 1,
    );
  }
}

////////////////////////////////////////////////////////////
/// 📍 Glass Address Card
////////////////////////////////////////////////////////////

class _GlassAddressCard extends StatelessWidget {
  final String address;
  const _GlassAddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              address,
              style: const TextStyle(
                color: Colors.black87, fontSize: 13, // add this
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: const [
              Icon(Icons.edit_outlined),
              SizedBox(height: 8),
              Icon(Icons.delete_outline, color: Colors.red),
            ],
          )
        ],
      ),
    );
  }
}

class _AnimatedGlassHeader extends StatefulWidget {
  const _AnimatedGlassHeader();

  @override
  State<_AnimatedGlassHeader> createState() => _AnimatedGlassHeaderState();
}

class _AnimatedGlassHeaderState extends State<_AnimatedGlassHeader> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = 220.0;
        final minHeight = kToolbarHeight;
        final current = constraints.biggest.height;

        final t = 1 -
            ((current - minHeight) / (maxHeight - minHeight)).clamp(0.0, 1.0);

        final avatarSize = lerpDouble(110, 42, t)!;
        final blur = lerpDouble(0, 22, t)!;

        return Stack(
          fit: StackFit.expand,
          children: [
            /// 🌊 Parallax Gradient Base
            Transform.translate(
              offset: Offset(0, -40 * t),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF5F5F7),
                      Color(0xFFEDEEF2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            /// 🧊 Dynamic Blur
            RepaintBoundary(
              child: ClipRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                ),
              ),
            ),

            /// 🪐 Elastic Avatar Morph
            Align(
              alignment: Alignment.lerp(
                Alignment.bottomCenter,
                Alignment.centerLeft,
                Curves.easeOut.transform(t),
              )!,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20 * t,
                  bottom: 30 * (1 - t),
                ),
                child: Transform.scale(
                  scale: lerpDouble(1.0, 0.8, t)!,
                  child: Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1 * (1 - t)),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EnquiryNotificationSection extends StatelessWidget {
  const _EnquiryNotificationSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Notification Cards (No Table UI)
        _LuxuryNotificationTile(
          count: 18,
          message: "Enquiry request in creation",
        ),

        const SizedBox(height: 18),

        _LuxuryNotificationTile(
          count: 6,
          message: "Enquiry request pending activation",
        ),
      ],
    );
  }
}

class _LuxuryNotificationTile extends StatelessWidget {
  final int count;
  final String message;

  const _LuxuryNotificationTile({
    required this.count,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            /// soft luxury depth
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 💎 Premium Count Capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2F80ED),
                    Color(0xFF56CCF2),
                  ],
                ),
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(width: 18),

            /// 📄 Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
