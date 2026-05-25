import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_vendor_chat_args.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tradologie_app/core/widgets/notifications_service.dart';
import 'package:tradologie_app/injection_container.dart';

class SelectVendorforChat extends StatefulWidget {
  const SelectVendorforChat({super.key});

  @override
  State<SelectVendorforChat> createState() => _SelectVendorforChatState();
}

class _SelectVendorforChatState extends State<SelectVendorforChat> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<FirebaseNotificationService>().markAppShellReady();
    });
  }

  void _onLogoutTap() {
    context.read<AuthenticationCubit>().adminLogout(NoParams());
  }

  void _openVendorChat(
    String categoryTitle, {
    String signalRType1 = AdminChatConfig.type1,
    String signalRType2 = AdminChatConfig.type2,
  }) {
    sl<NavigationService>().pushNamed(
      Routes.adminVendorChat,
      arguments: AdminVendorChatArgs(
        categoryTitle: categoryTitle,
        signalRType1: signalRType1,
        signalRType2: signalRType2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AdminLogoutSuccess) {
            CommonToast.success(state.message);
            sl<NavigationService>().pushNamedAndRemoveUntil(
              Routes.onboardingRoute,
            );
          }
          if (state is AdminLogoutError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                CommonAppbar(
                  title: 'Admin Dashboard',
                  expandedHeight: 64,
                  showSuffixIcon: true,
                  suffixIcon: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'logout') {
                        _onLogoutTap();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Image.asset(
                              ImgAssets.logout,
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyleConstants.regular(
                                context,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Business Category',
                          style: TextStyleConstants.semiBold(
                            context,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Choose a category to connect with vendors.',
                          style: TextStyleConstants.regular(
                            context,
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        BusinessCard(
                          title: 'Agro Commodity',
                          subtitle: 'Connect with Agro Seller.',
                          image: 'assets/images/agro_image.png',
                          onTap: () => _openVendorChat(
                            'Connect with Agro Seller',
                          ),
                        ),
                        BusinessCard(
                          title: 'Agro Commodity',
                          subtitle: 'Connect with Agro Buyer.',
                          image: 'assets/images/agro_image.png',
                          onTap: () => _openVendorChat(
                            'Connect with Agro Buyer',
                          ),
                        ),
                        BusinessCard(
                          title: 'FMCG & Packaged Food',
                          subtitle: 'Connect with FMCG Brand.',
                          image: 'assets/images/fmcg_image.jpg',
                          onTap: () => _openVendorChat(
                            'Connect with FMCG Brand',
                          ),
                        ),
                        BusinessCard(
                          title: 'FMCG & Packaged Food',
                          subtitle: 'Connect with FMCG Distributor.',
                          image: 'assets/images/fmcg_image.jpg',
                          onTap: () => _openVendorChat(
                            'Connect with FMCG Distributor',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              buildWhen: (previous, current) =>
                  current is AdminLogoutIsLoading ||
                  previous is AdminLogoutIsLoading,
              builder: (context, state) {
                if (state is AdminLogoutIsLoading) {
                  return const CommonLoader();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback? onTap;

  const BusinessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
  });

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: isPressed ? 0.96 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 12,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.55),
                        Colors.white.withValues(alpha: 0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTap,
                      splashColor: Colors.white.withValues(alpha: 0.2),
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(widget.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF1B3C59),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.subtitle,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chat_outlined,
                              size: 20,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
