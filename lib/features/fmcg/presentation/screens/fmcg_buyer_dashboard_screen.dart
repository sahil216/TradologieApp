import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
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
  String _searchQuery = '';
  SecureStorageService secureStorage = SecureStorageService();

  ChatCubit get chatCubit => BlocProvider.of(context);

  ChatList selectedChat = ChatList();

  void getBuyerBrandsList({
    String search = "",
  }) async {
    GetBuyerBrandsListParams params = GetBuyerBrandsListParams(
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      deviceID: Constants.deviceID,
      distributorID: await secureStorage.read(AppStrings.loginId) ?? "",
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
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshChats() async => getBuyerBrandsList();

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
                await secureStorage.read(AppStrings.loginId) ?? "";

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
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => enquiryCard(
                                distributorList?[i] ?? FmcgBuyerBrandsList(),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0A9FED).withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          /// 🔴 BRAND NAME (AMUL STYLE)
          CachedNetworkImage(
            imageUrl: enquiry.localInternalPath ?? "",
            height: 50,
            placeholder: (context, url) => CommonLoader(),
            errorWidget: (context, url, error) {
              debugPrint("Image load failed: $error");
              return const Icon(Icons.broken_image);
            },
            httpHeaders: const {
              "Connection": "keep-alive",
            },
          ),

          const SizedBox(height: 6),

          /// 👤 NAME
          Text(
            enquiry.brandName ?? "—",
            maxLines: 2,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B2B2B),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 DIVIDER
          Container(
            height: 1,
            color: const Color(0xFF0A9FED),
          ),

          const SizedBox(height: 16),

          /// 🔻 ACTION ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 👍 INTERESTED BUTTON
              GestureDetector(
                onTap: enquiry.isInterested == true
                    ? () {}
                    : () async {
                        final params = AddBuyerBrandInterestParams(
                          token: await secureStorage
                                  .read(AppStrings.apiVerificationCode) ??
                              "",
                          deviceID: Constants.deviceID,
                          brandID: enquiry.brandId.toString(),
                          distributorID:
                              await secureStorage.read(AppStrings.loginId) ??
                                  "",
                        );
                        chatCubit.addBuyerBrandInterest(params);
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
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
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 18,
                        color: enquiry.isInterested == true
                            ? const Color(0xFF0A9FED)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        enquiry.isInterested == true
                            ? "Interested - ${enquiry.totalInterestedDistributors == 0 ? "" : enquiry.totalInterestedDistributors}"
                            : "Interested - ${enquiry.totalInterestedDistributors == 0 ? "" : enquiry.totalInterestedDistributors}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: enquiry.isInterested == true
                              ? const Color(0xFF0A9FED)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ℹ️ TOOLTIP ICON
              Tooltip(
                message: enquiry.isInterested == true
                    ? "You have already shown interest"
                    : "Tap to show interest",
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  selectedChat.brandId = enquiry.brandId.toString();
                  selectedChat.userId = enquiry.brandName;

                  chatCubit.getInitialChatId(GetInitialChatIdParams(
                    token: await secureStorage
                            .read(AppStrings.apiVerificationCode) ??
                        "",
                    deviceId: Constants.deviceID,
                    buyerId: await secureStorage.read(AppStrings.loginId) ?? "",
                    brandId: enquiry.brandId.toString(),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2DAAE1),
                        Color(0xFF1B8ED1),
                      ],
                    ),
                  ),
                  child: const Text(
                    "Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  sl<NavigationService>().pushNamed(
                    Routes.fmcgProductCatalogueRoute,
                    arguments: enquiry.brandId.toString(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    "View Catalogue",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
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
