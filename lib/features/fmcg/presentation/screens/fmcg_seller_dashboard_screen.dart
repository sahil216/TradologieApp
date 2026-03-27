import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_fmcg_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';

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
  bool _showFilters = false;

  ChatCubit get chatCubit => BlocProvider.of(context);

  SecureStorageService secureStorage = SecureStorageService();

  void getDistributorList() async {
    await chatCubit.getDistributorList(NoParams());
  }

  @override
  void initState() {
    super.initState();
    getDistributorList();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshChats() async => getDistributorList();

  List<DistributorEnquiryList> get _filteredList {
    final source = distributorList ?? [];
    return source.where((e) {
      final matchSearch = _searchQuery.isEmpty ||
          (e.interestedBrandName?.toLowerCase().contains(_searchQuery) ??
              false) ||
          (e.perferredLocation?.toLowerCase().contains(_searchQuery) ??
              false) ||
          (e.name?.toLowerCase().contains(_searchQuery) ?? false);

      final matchLocation =
          _selectedLocation == null || e.perferredLocation == _selectedLocation;

      final matchBrand =
          _selectedBrand == null || e.interestedBrandName == _selectedBrand;

      return matchSearch && matchLocation && matchBrand;
    }).toList();
  }

  List<String> get _uniqueLocations {
    return (distributorList ?? [])
        .map((e) => e.perferredLocation ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  List<String> get _uniqueBrands {
    return (distributorList ?? [])
        .map((e) => e.interestedBrandName ?? '')
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

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
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is DistributorListSuccess) {
            setState(() => distributorList = state.data);
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
        },
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
                      CommonSliverAppBar(
                        title: 'Distributor Enquiry',
                        showSearch: true,
                        showFilter: true,
                        showBackButton: false,
                        onFilterPressed: () {},
                        onSearchChanged: (q) {},
                      ),
                      SliverToBoxAdapter(
                        child: const SizedBox(height: 16),
                      ),

                      // ── Grid ─────────────────────────────────────────────
                      _filteredList.isEmpty
                          ? SliverFillRemaining(
                              child: _EmptyState(
                                hasFilters: _hasActiveFilters,
                                onClear: _clearFilters,
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.62,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) => enquiryCard(
                                    _filteredList[i],
                                  ),
                                  childCount: _filteredList.length,
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
    );
  }

  String _initial(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  void _showConfirmation(BuildContext context, String distributorID) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          "Are you sure you want to connect with a distributor?",
          style: TextStyleConstants.semiBold(context, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          GestureDetector(
            onTap: () async {
              sl<NavigationService>().pop();
              AddDistributorInterestParams params =
                  AddDistributorInterestParams(
                      token: await secureStorage
                              .read(AppStrings.apiVerificationCode) ??
                          "",
                      deviceID: Constants.deviceID,
                      sellerID:
                          await secureStorage.read(AppStrings.loginId) ?? "",
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 HEADER
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A9FED).withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Text(
                      _initial(enquiry.name),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0A9FED),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    enquiry.name ?? "—",
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔹 DIVIDER
            Container(
              height: 1,
              color: const Color(0xFF0A9FED).withValues(alpha: 0.3),
            ),

            const SizedBox(height: 14),

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
              text: enquiry.interestedBrandName ?? "—",
            ),

            const SizedBox(height: 18),

            /// 🔹 BUTTON
            Center(
              child: GestureDetector(
                onTap: () => _showConfirmation(
                    context, enquiry.quotationUserId.toString()),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
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
                    "Contact",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
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
