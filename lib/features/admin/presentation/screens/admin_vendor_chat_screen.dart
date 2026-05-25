import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/admin/domain/entities/admin_vendor.dart';
import 'package:tradologie_app/features/admin/domain/usecases/get_admin_vendor_list_usecase.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_vendor_cubit.dart';
import 'package:tradologie_app/features/admin/presentation/screens/admin_vendor_conversation_screen.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_vendor_chat_args.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/admin_vendor_list_tile.dart';
import 'package:tradologie_app/injection_container.dart';

class AdminVendorChatScreen extends StatelessWidget {
  final AdminVendorChatArgs args;

  const AdminVendorChatScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminVendorCubit>()..loadRecentChats(),
      child: _AdminVendorChatBody(args: args),
    );
  }
}

class _AdminVendorChatBody extends StatefulWidget {
  final AdminVendorChatArgs args;

  const _AdminVendorChatBody({required this.args});

  @override
  State<_AdminVendorChatBody> createState() => _AdminVendorChatBodyState();
}

class _AdminVendorChatBodyState extends State<_AdminVendorChatBody> {
  final TextEditingController _searchController = TextEditingController();
  AdminVendorSearchType _searchType = AdminVendorSearchType.name;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onQueryChanged);
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching =>
      _searchController.text.trim().length >= AdminVendorCubit.minSearchLength;

  void _onQueryChanged() {
    setState(() {});
    final query = _searchController.text;
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().length < AdminVendorCubit.minSearchLength) {
      context.read<AdminVendorCubit>().restoreRecentChats();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      context.read<AdminVendorCubit>().searchVendors(
            query: query,
            searchType: _searchType,
          );
    });
  }

  void _onSearchTypeChanged(AdminVendorSearchType type) {
    if (_searchType == type) return;
    setState(() => _searchType = type);
    if (_searchController.text.trim().length >=
        AdminVendorCubit.minSearchLength) {
      context.read<AdminVendorCubit>().searchVendors(
            query: _searchController.text,
            searchType: type,
          );
    }
  }

  String get _searchHint {
    switch (_searchType) {
      case AdminVendorSearchType.name:
        return 'Search by vendor name';
      case AdminVendorSearchType.mobile:
        return 'Search by mobile number';
      case AdminVendorSearchType.email:
        return 'Search by email';
    }
  }

  void _openConversation(AdminVendor vendor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminVendorConversationScreen(
          vendor: vendor,
          chatType1: widget.args.signalRType1,
          chatType2: widget.args.signalRType2,
        ),
      ),
    );
  }

  String _emptyMessage(bool isSearchResults) {
    if (isSearchResults) return 'No vendors found';
    return 'No recent chats yet.\nSearch by name, mobile, or email.';
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocConsumer<AdminVendorCubit, AdminVendorState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AdminVendorListError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        builder: (context, state) {
          final vendors = state is AdminVendorListSuccess
              ? state.vendors
              : <AdminVendor>[];
          final isSearchResults =
              state is AdminVendorListSuccess && state.isSearchResults;
          final isLoading = state is AdminVendorListLoading;
          final listTitle = isSearchResults ? 'Search results' : 'Recent chats';

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  if (_isSearching) {
                    await context.read<AdminVendorCubit>().searchVendors(
                          query: _searchController.text,
                          searchType: _searchType,
                        );
                  } else {
                    await context.read<AdminVendorCubit>().loadRecentChats();
                  }
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    CommonAppbar(
                      title: 'Chat',
                      expandedHeight: 64,
                      showBackButton: true,
                      onBackTap: () => sl<NavigationService>().pop(),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.args.categoryTitle,
                              style: TextStyleConstants.semiBold(
                                context,
                                fontSize: 15,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SearchTypeSelector(
                              selected: _searchType,
                              onChanged: _onSearchTypeChanged,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _searchController,
                              keyboardType: _searchType ==
                                      AdminVendorSearchType.mobile
                                  ? TextInputType.phone
                                  : _searchType == AdminVendorSearchType.email
                                      ? TextInputType.emailAddress
                                      : TextInputType.text,
                              decoration: InputDecoration(
                                hintText: _searchHint,
                                prefixIcon:
                                    const Icon(Icons.search, size: 22),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          _searchController.clear();
                                          context
                                              .read<AdminVendorCubit>()
                                              .restoreRecentChats();
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isSearching
                                  ? 'Showing search results in the list below'
                                  : 'Type at least ${AdminVendorCubit.minSearchLength} characters to search',
                              style: TextStyleConstants.regular(
                                context,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (vendors.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                          child: Text(
                            listTitle,
                            style: TextStyleConstants.semiBold(
                              context,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    if (vendors.isEmpty && !isLoading)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _emptyMessage(isSearchResults),
                              textAlign: TextAlign.center,
                              style: TextStyleConstants.regular(
                                context,
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final vendor = vendors[index];
                            return AdminVendorListTile(
                              vendor: vendor,
                              onTap: () => _openConversation(vendor),
                            );
                          },
                          childCount: vendors.length,
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
              if (isLoading) const CommonLoader(),
            ],
          );
        },
      ),
    );
  }
}

class _SearchTypeSelector extends StatelessWidget {
  final AdminVendorSearchType selected;
  final ValueChanged<AdminVendorSearchType> onChanged;

  const _SearchTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AdminVendorSearchType.values.map((type) {
        final isSelected = selected == type;
        final label = switch (type) {
          AdminVendorSearchType.name => 'Name',
          AdminVendorSearchType.mobile => 'Mobile',
          AdminVendorSearchType.email => 'Email',
        };
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: type != AdminVendorSearchType.email ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyleConstants.medium(
                    context,
                    fontSize: 13,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
