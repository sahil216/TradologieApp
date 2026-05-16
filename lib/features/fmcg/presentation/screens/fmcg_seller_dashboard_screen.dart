import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/dashboard_mobile_flow.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_fmcg_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_category_list.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_distributor_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';
import 'package:tradologie_app/features/fmcg/presentation/widgets/category_filter_sheet.dart';

class FmcgSellerDashboardScreen extends StatefulWidget {
  const FmcgSellerDashboardScreen({super.key});

  @override
  State<FmcgSellerDashboardScreen> createState() =>
      _FmcgSellerDashboardScreenState();
}

class _FmcgSellerDashboardScreenState extends State<FmcgSellerDashboardScreen> {
  List<DistributorEnquiryList>? distributorList;

  // Search & Filter state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedLocation;
  String? _selectedBrand;
  Set<String> _selectedCategories = {};

  ChatCubit get chatCubit => BlocProvider.of(context);

  AuthenticationCubit get authenticationCubit => BlocProvider.of(context);

  final SecureStorageService _secureStorage = SecureStorageService();

  String _countryCode = '';
  String _mobileNumber = '';
  bool _postDashboardFlowHandled = false;

  Future<void> getDistributorList({
    String search = "",
    Set<String>? categories,
  }) async {
    GetDistributorListParams params = GetDistributorListParams(
      token: await _secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      deviceID: Constants.deviceID,
      searchText: search,
      category: categories == null || categories.isEmpty
          ? ""
          : categories.join("###"),
    );

    await chatCubit.getDistributorList(params);
  }

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    getDistributorList();
    authenticationCubit.fmcgBuyerCategoryList(NoParams());
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadMobileFromStorage();
      if (mounted) await _loadPhoneFromSellerProfile();
    });
  }

  Future<void> _loadPhoneFromSellerProfile() async {
    final params = GetSellerProfileParams(
      token: await _secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      loginID: await _secureStorage.read(AppStrings.loginId) ?? "",
      deviceID: Constants.deviceID,
    );
    await chatCubit.getSellerProfile(params);
  }

  Future<void> _applySellerProfilePhone(FmcgGetSellerProfile profile) async {
    final phone = DashboardMobileFlow.phoneFromProfile(
      mobile: profile.mobile,
      countryCode: profile.countryCode,
    );
    if (phone == null) return;

    await DashboardMobileFlow.persist(_secureStorage, phone);
    if (!mounted) return;
    setState(() {
      _countryCode = phone.countryCode;
      _mobileNumber = phone.mobileNumber;
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

  /// Google hint (Android) prefill → mobile number dialog.
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
      type: DashboardMobileType.fmcgSeller,
      phone: saved,
    );
    if (!mounted) return;
    if (message != null && message.isNotEmpty) {
      CommonToast.success(message);
    } else {
      CommonToast.error('Could not update mobile number');
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      distributorList?.clear();
      getDistributorList(
        search: query,
        categories: _selectedCategories,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FmcgBuyerCategoryList>? fmcgBuyerCategoryList;

  Future<void> _refreshChats() async => getDistributorList();

  void _clearFilters() {
    setState(() {
      _selectedLocation = null;
      _selectedBrand = null;
      _searchController.clear();
    });
  }

  bool get _hasActiveFilters =>
      _selectedLocation != null ||
      _selectedBrand != null ||
      _searchQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatCubit, ChatState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) async {
              if (state is DistributorListSuccess) {
                distributorList = state.data;
              }
              if (state is DistributorListError) {
                CommonToast.showFailureToast(state.failure);
              }
              if (state is AddDistributorInterestSuccess) {
                CommonToast.success(
                    "Thank you for your interest! Our sales team will connect with you shortly to explain how the platform works.");
              }
              if (state is AddDistributorInterestError) {
                CommonToast.showFailureToast(state.failure);
              }
              if (state is GetSellerProfileSuccess) {
                await _applySellerProfilePhone(state.data);
                if (mounted) await _runPostDashboardFlow();
              }
              if (state is GetSellerProfileError) {
                if (mounted) await _runPostDashboardFlow();
              }
            },
          ),
          BlocListener<AuthenticationCubit, AuthenticationState>(
              listenWhen: (previous, current) => previous != current,
              listener: (context, state) async {
                if (state is FmcgBuyerCategoryListSuccess) {
                  fmcgBuyerCategoryList = state.data;

                  setState(() {});
                }
              }),
        ],
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
                          title: "Distributor Enquiry",
                          showBackButton: false,
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SearchBarDelegate(
                            showFilter: true,
                            onFilterPressed: () {
                              _openCategoryFilter();
                            },
                            onSearchChanged: _onSearchChanged,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: const SizedBox(height: 16),
                        ),

                        // ── Grid ─────────────────────────────────────────────
                        (distributorList?.isEmpty ?? true)
                            ? SliverFillRemaining(
                                child: _EmptyState(
                                  hasFilters: _hasActiveFilters,
                                  onClear: _clearFilters,
                                ),
                              )
                            : SliverPadding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 32),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.55,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, i) =>
                                        enquiryCard(distributorList![i]),
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
                  if (state is DistributorListIsLoading ||
                      state is AddDistributorInterestIsLoading) {
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

  String _initial(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  void _openCategoryFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return CategoryFilterSheet(
          selectedCategories: _selectedCategories,
          categories: fmcgBuyerCategoryList ?? [],
          onApply: (values) {
            distributorList?.clear();
            setState(() => _selectedCategories = values);

            getDistributorList(
              search: _searchController.text,
              categories: values,
            );
          },
        );
      },
    );
  }

  void _showConfirmation(BuildContext context, String distributorID) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          "Are you sure want to connect with distributor?",
          style: TextStyleConstants.semiBold(context, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              sl<NavigationService>().pop();
            },
            child: const Text("Cancel"),
          ),
          GestureDetector(
            onTap: () async {
              sl<NavigationService>().pop();
              AddDistributorInterestParams params =
                  AddDistributorInterestParams(
                      token: await _secureStorage
                              .read(AppStrings.apiVerificationCode) ??
                          "",
                      deviceID: Constants.deviceID,
                      sellerID:
                          await _secureStorage.read(AppStrings.loginId) ?? "",
                      distributorID: distributorID);
              chatCubit.addDistributorInterest(params);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 10,
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
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget enquiryCard(
    DistributorEnquiryList enquiry,
  ) {
    final hideSensitive = Constants().hideSensitiveData ?? true;

    final phone = enquiry.mobile != null
        ? "${enquiry.countryCode ?? ""} ${hideSensitive ? Constants().maskPhone(enquiry.mobile ?? "") : enquiry.mobile!}"
        : null;

    final email = enquiry.email != null
        ? (hideSensitive
            ? Constants().maskEmail(enquiry.email ?? "")
            : enquiry.email!)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0A9FED).withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 HEADER — name centered on card; avatar on left
            SizedBox(
              height: 48,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              const Color(0xFF0A9FED).withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Text(
                            _initial(enquiry.name),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0A9FED),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 48, right: 4),
                      child: Center(
                        child: Text(
                          enquiry.name ?? "—",
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
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🔹 DIVIDER
            Container(
              height: 1,
              color: const Color(0xFF0A9FED).withValues(alpha: 0.3),
            ),

            const SizedBox(height: 10),

            /// 🔹 DETAILS
            _RowItem(
              icon: Icons.location_on,
              color: Colors.green,
              text: enquiry.perferredLocation ?? "—",
            ),

            const SizedBox(height: 10),

            if (phone != null)
              _RowItem(
                icon: Icons.phone,
                color: Colors.blue,
                text: phone,
              ),

            const SizedBox(height: 10),

            if (email != null)
              _RowItem(
                icon: Icons.mail,
                color: Colors.orange,
                text: email,
              ),

            const SizedBox(height: 10),

            _RowItem(
              icon: Icons.category,
              color: Colors.deepPurple,
              text: enquiry.fMCGCategory ?? "—",
            ),

            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enquiry.isInterest == true) ...[
                  Icon(Icons.thumb_up ,
                      size: 22, color: const Color(0xFF6390DD)),
                  const SizedBox(height: 2),
                  Text(
                    'Liked you',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6390DD).withValues(alpha: 0.95),
                      height: 1.1,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            /// 🔹 BUTTON — full width, fixed height (no clipping)
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showConfirmation(
                        context, enquiry.quotationUserId.toString()),
                    borderRadius: BorderRadius.circular(22),
                    child: Ink(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF2DAAE1),
                            Color(0xFF1B8ED1),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Connect",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _RowItem({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3A3A3A),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onClear;

  const _EmptyState({required this.hasFilters, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasFilters ? Icons.search_off_rounded : Icons.inbox_outlined,
            size: 40,
            color: T.muted,
          ),
          const SizedBox(height: 12),
          Text(
            hasFilters ? 'No results match your filters' : 'Nothing here yet',
            style: T.body.copyWith(color: T.muted),
          ),
          if (hasFilters) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: T.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Clear filters',
                    style: T.body.copyWith(color: T.blue)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
