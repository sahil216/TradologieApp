import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_fmcg_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/contact_us/more_options_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/fmcg_documents_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/stepper_screens/fmcg_profile_screen.dart';
import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import '../../../../core/utils/app_strings.dart';

class _FmcgMyAccountTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FmcgMyAccountTabBarDelegate(this.child);

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _FmcgMyAccountTabBarDelegate oldDelegate) {
    return false;
  }
}

class FmcgMyAccountScreen extends StatefulWidget {
  const FmcgMyAccountScreen({super.key});

  @override
  State<FmcgMyAccountScreen> createState() => _FmcgMyAccountScreenState();
}

class _FmcgMyAccountScreenState extends State<FmcgMyAccountScreen>
    with TickerProviderStateMixin {
  final SecureStorageService _secureStorage = SecureStorageService();
  String? token;
  CompanyDetails? companyDetails;
  late TabController _tabController;
  int _previousIndex = 0;

  MyAccountCubit get cubit => BlocProvider.of<MyAccountCubit>(context);

  // Future<void> getCompanyDetails() async {
  //   await cubit.companyDetails(NoParams());
  // }

  @override
  void initState() {
    super.initState();
    _loadToken();
    // getCompanyDetails();

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _handleTabChange(_tabController.index);
      }
    });
  }

  void _handleTabChange(int newIndex) {
    bool canOpen = _canOpenTab(newIndex);

    if (!canOpen) {
      Future.microtask(() {
        _tabController.index = _previousIndex;
      });
    } else {
      _previousIndex = newIndex;
    }
  }

  bool _canOpenTab(int index) {
    return true;
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  Future<void> _loadToken() async {
    final _token = await _secureStorage.read(AppStrings.apiVerificationCode);
    setState(() {
      token = _token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MyAccountCubit, MyAccountState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              if (state is CompanyDetailsSuccess) {
                companyDetails = state.data;
              }
              if (state is CompanyDetailsError) {
                CommonToast.showFailureToast(state.failure);
              }
            },
          ),
        ],
        child: AdaptiveScaffold(
          body: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              /// ⭐ ULTRA COMMON APPBAR
              CommonSliverAppBar(
                title: "My Account",
                showBackButton: false,
              ),

              /// ⭐ PINNED TABBAR (EXACT SAME UI)
              SliverPersistentHeader(
                pinned: true,
                delegate: _FmcgMyAccountTabBarDelegate(
                  CommonTabBarWidget(
                    controller: _tabController,
                    tabs: const [
                      "Information",
                      "Documents",
                      "More Options",
                    ],
                    isEnabled: (index) {
                      return true;
                    },
                  ),
                ),
              ),
              SliverFillRemaining(
                child: BlocBuilder<MyAccountCubit, MyAccountState>(
                  buildWhen: (previous, current) {
                    bool result = previous != current;
                    result = result &&
                        (current is CompanyDetailsSuccess ||
                            current is CompanyDetailsError ||
                            current is CompanyDetailsIsLoading);
                    return result;
                  },
                  builder: (context, state) {
                    // if (state is CompanyDetailsError) {
                    //   if (state.failure is NetworkFailure) {
                    //     return CustomErrorNetworkWidget(
                    //       onPress: () {
                    //         getCompanyDetails();
                    //       },
                    //     );
                    //   } else if (state.failure is UserFailure) {
                    //     return CustomErrorWidget(
                    //       onPress: () {
                    //         getCompanyDetails();
                    //       },
                    //       errorText: state.failure.msg,
                    //     );
                    //   }
                    // }

                    /// 👇 KEEP YOUR ORIGINAL TABBARVIEW EXACTLY SAME
                    return TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        FmcgProfileScreen(),
                        FmcgDocumentsScreen(),
                        MoreOptionsScreen()
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonTabBarWidget extends StatefulWidget {
  final TabController controller;
  final List<String> tabs;
  final bool Function(int index)? isEnabled;

  const CommonTabBarWidget({
    super.key,
    required this.controller,
    required this.tabs,
    this.isEnabled,
  });

  @override
  State<CommonTabBarWidget> createState() => _CommonTabBarWidgetState();
}

class _CommonTabBarWidgetState extends State<CommonTabBarWidget> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();
    _keys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
    widget.controller.addListener(_centerSelectedTab);
  }

  void _centerSelectedTab() {
    if (!_scrollController.hasClients) return;

    final index = widget.controller.index;
    final ctx = _keys[index].currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);

    final screenWidth = MediaQuery.of(context).size.width;
    final target = _scrollController.offset +
        pos.dx -
        screenWidth / 2 +
        box.size.width / 2;

    _scrollController.animateTo(
      target.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_centerSelectedTab);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller.animation!,
      builder: (context, _) {
        final progress = widget.controller.animation!.value;

        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: Colors.white.withValues(alpha: .5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .08),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              /// ⭐ SHADER EDGE FADE (NO OVERLAY BLOCKS)
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.tabs.length,
                itemBuilder: (context, index) {
                  final selected = widget.controller.index == index;
                  final enabled = widget.isEnabled?.call(index) ?? true;

                  final stretch =
                      (1 - (progress - index).abs()).clamp(0.9, 1.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: enabled
                          ? () => widget.controller.animateTo(index)
                          : null,
                      child: Transform.scale(
                        scale: stretch,
                        child: AnimatedContainer(
                          key: _keys[index],
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Opacity(
                            opacity: enabled ? 1 : .3,
                            child: Text(
                              widget.tabs[index],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
