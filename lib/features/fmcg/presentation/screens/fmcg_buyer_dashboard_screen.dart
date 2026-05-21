import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/dashboard_mobile_flow.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_fmcg_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_brand_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_brands_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_initial_chat_id_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_main_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_products_screen.dart';

import '../../../../injection_container.dart';

class FmcgBuyerDashboardScreen extends StatefulWidget {
  const FmcgBuyerDashboardScreen({super.key});

  @override
  State<FmcgBuyerDashboardScreen> createState() =>
      _FmcgBuyerDashboardScreenState();
}

class _FmcgBuyerDashboardScreenState extends State<FmcgBuyerDashboardScreen> {
  List<FmcgBuyerBrandsList>? distributorList;

  // Search & Filter state
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  final SecureStorageService _secureStorage = SecureStorageService();

  String _countryCode = '';
  String _mobileNumber = '';
  bool _postDashboardFlowHandled = false;

  ChatCubit get chatCubit => BlocProvider.of(context);

  ChatList selectedChat = ChatList();

  void getBuyerBrandsList({
    String search = "",
  }) async {
    GetBuyerBrandsListParams params = GetBuyerBrandsListParams(
      token: await _secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      deviceID: Constants.deviceID,
      distributorID: await _secureStorage.read(AppStrings.loginId) ?? "",
      searchText: search,
    );
    await chatCubit.getBuyerBrandsList(params);
  }

  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      distributorList?.clear();
      getBuyerBrandsList(
        search: query,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getBuyerBrandsList();
    _searchController.addListener(() {
      setState(() => searchQuery = _searchController.text.toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadMobileFromStorage();
      if (mounted) await _runPostDashboardFlow();
    });
  }

  Future<void> _loadMobileFromStorage() async {
    final phone = await DashboardMobileFlow.loadFromStorage(_secureStorage);
    if (!mounted) return;
    setState(() {
      _countryCode = phone.countryCode;
      _mobileNumber = phone.mobileNumber;
    });
  }

  Future<void> _runPostDashboardFlow() async {
    if (_postDashboardFlowHandled) return;
    _postDashboardFlowHandled = true;

    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    final saved = await DashboardMobileFlow.collectMobileIfNeeded(
      context: context,
      countryCode: _countryCode,
      mobileNumber: _mobileNumber,
    );

    if (!mounted) return;

    if (saved != null) {
      await _saveAndSyncMobile(saved);
    }
  }

  Future<void> _saveAndSyncMobile(StoredPhone saved) async {
    await DashboardMobileFlow.persist(_secureStorage, saved);
    if (!mounted) return;
    setState(() {
      _countryCode = saved.countryCode;
      _mobileNumber = saved.mobileNumber;
    });

    final message = await DashboardMobileFlow.syncMobileToServer(
      storage: _secureStorage,
      type: DashboardMobileType.fmcgBuyer,
      phone: saved,
    );
    if (!mounted) return;
    if (message != null && message.isNotEmpty) {
      CommonToast.success(message);
    } else {
      CommonToast.error('Could not update mobile number');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshChats() async => getBuyerBrandsList();

  /// Taller cards on small screens so Connect / catalogue actions are not clipped.
  double _gridChildAspectRatio(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.height < 700 || size.width < 360) return 0.50;
    if (size.height < 800) return 0.56;
    return 0.62;
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is GetBuyerBrandsListSuccess) {
            setState(() => distributorList = state.data);
          }
          if (state is GetBuyerBrandsListError) {
            // CommonToast.showFailureToast(state.failure);
          }
          if (state is AddBuyerBrandInterestSuccess) {
            // distributorList?.clear();
            getBuyerBrandsList();
          }
          if (state is AddBuyerBrandInterestError) {
            // CommonToast.showFailureToast(state.failure);
          }
          if (state is GetInitialChatIdSuccess) {
            selectedChat.sellerId = state.data.sellerId.toString();
            selectedChat.quotationUserId =
                await _secureStorage.read(AppStrings.loginId) ?? "";

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chat: selectedChat,
                ),
              ),
            );
          }
          if (state is GetInitialChatIdError) {
            // CommonToast.showFailureToast(state.failure);
          }
        },
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: _refreshChats,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        // ── App Bar ─────────────────────────────────────────
                        CommonAppbar(
                          title: 'Brand Hub',
                          showBackButton: false,
                          showNotification: false,
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SearchBarDelegate(
                            showFilter: false,
                            onSearchChanged: _onSearchChanged,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: const SizedBox(height: 16),
                        ),

                        // ── Grid ─────────────────────────────────────────────
                        // _filteredList.isEmpty
                        //     ? SliverFillRemaining(
                        //         child: _EmptyState(
                        //           hasFilters: _hasActiveFilters,
                        //           onClear: _clearFilters,
                        //         ),
                        //       )
                        //     :
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: _gridChildAspectRatio(context),
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => GestureDetector(
                                onTap: () async {
                                  NavBarVisibility.of(context).show();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FmcgProductsScreen(
                                          params: ProductsListParams(
                                        brandId: distributorList?[i]
                                                .brandId
                                                .toString() ??
                                            "",
                                        brandName: distributorList?[i]
                                                .brandName
                                                .toString() ??
                                            "",
                                      )),
                                    ),
                                  );
                                  // sl<NavigationService>().pushNamed(
                                  //     Routes.fmcgProductCatalogueRoute,
                                  //     arguments: ProductsListParams(
                                  //       brandId: distributorList?[i]
                                  //               .brandId
                                  //               .toString() ??
                                  //           "",
                                  //       brandName: distributorList?[i]
                                  //               .brandName
                                  //               .toString() ??
                                  //           "",
                                  //     ));
                                },
                                child: enquiryCard(
                                  distributorList?[i] ?? FmcgBuyerBrandsList(),
                                ),
                              ),
                              childCount: distributorList?.length ?? 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ── Loading overlay ─────────────────────────────────────────
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is GetBuyerBrandsListIsLoading ||
                      state is AddBuyerBrandInterestIsLoading ||
                      state is GetInitialChatIdIsLoading) {
                    return const Positioned.fill(child: CommonLoader());
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget enquiryCard(FmcgBuyerBrandsList enquiry) {
    final interestedCount = enquiry.totalInterestedDistributors ?? 0;
    final interestedLabel = interestedCount > 0
        ? 'Interested ($interestedCount)'
        : 'Interested';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0A9FED).withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl: enquiry.localInternalPath ?? '',
            height: 44,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(
              height: 44,
              child: Center(child: CommonLoader()),
            ),
            errorWidget: (context, url, error) {
              debugPrint('Image load failed: $error');
              return const SizedBox(
                height: 44,
                child: Icon(Icons.broken_image, size: 28),
              );
            },
            httpHeaders: const {
              'Connection': 'keep-alive',
            },
          ),
          const SizedBox(height: 6),
          Text(
            enquiry.brandName ?? '—',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B2B2B),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: const Color(0xFF0A9FED)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: enquiry.isInterested == true
                      ? null
                      : () async {
                          final params = AddBuyerBrandInterestParams(
                            token: await _secureStorage
                                    .read(AppStrings.apiVerificationCode) ??
                                '',
                            deviceID: Constants.deviceID,
                            brandID: enquiry.brandId.toString(),
                            distributorID: await _secureStorage
                                    .read(AppStrings.loginId) ??
                                '',
                          );
                          chatCubit.addBuyerBrandInterest(params);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: enquiry.isInterested == true
                          ? const Color(0xFF0A9FED).withValues(alpha: 0.15)
                          : Colors.transparent,
                      border: Border.all(
                        color: enquiry.isInterested == true
                            ? const Color(0xFF0A9FED)
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          size: 16,
                          color: enquiry.isInterested == true
                              ? const Color(0xFF0A9FED)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            interestedLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: enquiry.isInterested == true
                                  ? const Color(0xFF0A9FED)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: enquiry.isInterested == true
                    ? 'You have already shown interest'
                    : 'Tap to show interest',
                child: const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          _BrandCardActionButton(
            label: 'Connect',
            filled: true,
            onTap: () async {
              selectedChat.brandId = enquiry.brandId.toString();
              selectedChat.userId = enquiry.brandName;

              chatCubit.getInitialChatId(
                GetInitialChatIdParams(
                  token: await _secureStorage
                          .read(AppStrings.apiVerificationCode) ??
                      '',
                  deviceId: Constants.deviceID,
                  buyerId:
                      await _secureStorage.read(AppStrings.loginId) ?? '',
                  brandId: enquiry.brandId.toString(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _BrandCardActionButton(
            label: 'View Catalogue',
            filled: false,
            onTap: () async {
              NavBarVisibility.of(context).show();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FmcgProductsScreen(
                    params: ProductsListParams(
                      brandId: enquiry.brandId.toString(),
                      brandName: enquiry.brandName.toString(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BrandCardActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _BrandCardActionButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: filled
              ? const LinearGradient(
                  colors: [Color(0xFF2DAAE1), Color(0xFF1B8ED1)],
                )
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            decoration: filled ? null : TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
