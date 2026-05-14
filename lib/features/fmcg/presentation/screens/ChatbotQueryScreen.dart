import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_query_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_query_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chatbot_tran_screen.dart';
import 'package:tradologie_app/injection_container.dart';

class Chatbotqueryscreen extends StatefulWidget {
  const Chatbotqueryscreen({super.key});

  @override
  State<Chatbotqueryscreen> createState() => _ChatbotqueryscreenState();
}

class _ChatbotqueryscreenState extends State<Chatbotqueryscreen> {
  final TextEditingController _searchController = TextEditingController();
  final SecureStorageService _secureStorage = SecureStorageService();

  int _currentPage = 1;
  static const int _notificationCount = 1;

  /// Holds last successful payload while a new page is loading.
  ChatbotQueryListSuccess? _cachedSuccess;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchPage(_currentPage));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int page) async {
    if (!mounted) return;
    setState(() {
      _currentPage = page;
    });

    final token =
        await _secureStorage.read(AppStrings.apiVerificationCode) ?? '';
    final loginIdStr = await _secureStorage.read(AppStrings.loginId) ?? '0';
    final userId = int.tryParse(loginIdStr) ?? 0;

    if (!mounted) return;
    context.read<ChatCubit>().getChatbotQueryList(
          ChatbotQueryListParams(
            token: token,
            deviceId: Constants.deviceID,
            userId: userId,
            indexNo: page,
          ),
        );
  }

  List<ChatbotQueryListItem> _filtered(List<ChatbotQueryListItem> items) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.uid.toLowerCase().contains(q) ||
          e.email.toLowerCase().contains(q) ||
          e.mobile.contains(q) ||
          e.optionText.toLowerCase().contains(q) ||
          e.country.toLowerCase().contains(q) ||
          e.updatedDate.toLowerCase().contains(q);
    }).toList();
  }

  static const _headerBlue = Color(0xFF1E88E5);
  static const _pageBg = Color(0xFFF0F2F5);
  static const _searchBorder = Color(0xFF90CAF9);
  static const _searchHint = Color(0xFF64B5F6);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (p, c) =>
          c is ChatbotQueryListSuccess ||
          c is ChatbotQueryListError ||
          c is ChatbotQueryListLoading,
      listener: (context, state) {
        if (state is ChatbotQueryListSuccess) {
          _cachedSuccess = state;
        }
        if (state is ChatbotQueryListError) {
          CommonToast.showFailureToast(state.failure);
        }
      },
      buildWhen: (p, c) =>
          c is ChatbotQueryListLoading ||
          c is ChatbotQueryListSuccess ||
          c is ChatbotQueryListError ||
          c is ChatInitial,
      builder: (context, state) {
        final loading = state is ChatbotQueryListLoading;
        final data = state is ChatbotQueryListSuccess ? state : _cachedSuccess;
        final items = data == null ? <ChatbotQueryListItem>[] : data.items;
        final totalPages = data?.totalPages ?? 1;
        final pageItems = _filtered(items);

        return Scaffold(
          backgroundColor: _pageBg,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    CommonAppbar(
                      title: 'Chatbot Query',
                      showBackButton: true,
                      showNotification: false,
                      showSuffixIcon: true,
                    ),
                    SliverToBoxAdapter(child: _buildSearchField()),
                    if (loading && data == null)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      if (loading && data != null)
                        const SliverToBoxAdapter(
                          child: LinearProgressIndicator(minHeight: 2),
                        ),
                      if (data != null && items.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No data',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else if (data != null && pageItems.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No results',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else if (data != null && pageItems.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final e = pageItems[i];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        i < pageItems.length - 1 ? 12 : 0,
                                  ),
                                  child: _QueryCard(
                                    item: e,
                                    onOpen: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.chatbotTranScreen,
                                        arguments: ChatbotTranScreenArgs(
                                          chatMainId: e.chatMainId,
                                          contactName: e.name,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              childCount: pageItems.length,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              if (data != null && totalPages > 1)
                _buildPagination(totalPages),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _searchBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black, fontSize: 15),
          cursorColor: _headerBlue,
          decoration: InputDecoration(
            hintText: 'Advance search',
            hintStyle: GoogleFonts.dmSans(
              color: _searchHint.withValues(alpha: 0.85),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: _headerBlue.withValues(alpha: 0.9),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: _pageBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pageBtn(
            icon: Icons.keyboard_double_arrow_left_rounded,
            onTap: () => _fetchPage(1),
            disabled: _currentPage <= 1,
          ),
          _pageBtn(
            icon: Icons.chevron_left_rounded,
            onTap: () => _fetchPage(_currentPage - 1),
            disabled: _currentPage <= 1,
          ),
          ..._pageNumberWidgets(totalPages),
          _pageBtn(
            icon: Icons.chevron_right_rounded,
            onTap: () => _fetchPage(_currentPage + 1),
            disabled: _currentPage >= totalPages,
          ),
          _pageBtn(
            icon: Icons.keyboard_double_arrow_right_rounded,
            onTap: () => _fetchPage(totalPages),
            disabled: _currentPage >= totalPages,
          ),
        ],
      ),
    );
  }

  List<Widget> _pageNumberWidgets(int totalPages) {
    if (totalPages <= 1) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _pageNumber(1, true, () {}),
        ),
      ];
    }

    final pages = <int>{
      1,
      totalPages,
      _currentPage,
      if (_currentPage > 1) _currentPage - 1,
      if (_currentPage < totalPages) _currentPage + 1,
    };
    final sorted = pages.toList()..sort();
    final widgets = <Widget>[];
    int? lastAdded;
    for (final p in sorted) {
      if (p < 1 || p > totalPages) continue;
      if (lastAdded != null && p - lastAdded > 1) {
        widgets.add(_ellipsis());
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _pageNumber(
            p,
            p == _currentPage,
            () => _fetchPage(p),
          ),
        ),
      );
      lastAdded = p;
    }
    return widgets;
  }

  Widget _ellipsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '...',
        style: TextStyle(
          color: _headerBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _pageNumber(int n, bool active, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: active ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? _headerBlue : _searchBorder,
              width: 1.2,
            ),
            color: active ? _headerBlue : Colors.white,
          ),
          child: Text(
            '$n',
            style: TextStyle(
              color: active ? Colors.white : _headerBlue,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _pageBtn({
    required IconData icon,
    required VoidCallback onTap,
    required bool disabled,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _searchBorder),
            ),
            child: Icon(
              icon,
              size: 22,
              color: disabled ? Colors.grey.shade400 : _headerBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class _QueryCard extends StatefulWidget {
  final ChatbotQueryListItem item;
  final VoidCallback onOpen;

  const _QueryCard({
    required this.item,
    required this.onOpen,
  });

  @override
  State<_QueryCard> createState() => _QueryCardState();
}

class _QueryCardState extends State<_QueryCard> {
  bool _expanded = false;

  static String _formatMobile(String m) {
    final digits = m.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) return '+91-$digits';
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final mobileDisplay = _formatMobile(item.mobile);
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: widget.onOpen,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _pair('Name', item.name),
                          _pair('Mobile No.', mobileDisplay),
                          _pair('Query Date', item.updatedDate),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => _expanded = !_expanded),
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        turns: _expanded ?  0.75:0.25,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey.shade500,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? InkWell(
                    onTap: widget.onOpen,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Divider(height: 1, color: Colors.grey.shade200),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    _pair('Email', item.email),
                                    _pair('Option', item.optionText),
                                    _pair('Country', item.country),
                                   /* _pair(
                                      'Annual Turnover',
                                      item.annualTurnover,
                                    ),
                                    _pair('Message', item.message),*/
                                  ],
                                ),
                              ),
                             /* Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    _pair('UID', item.uid),
                                    _pair('IP Address', item.ipAddress),
                                    _pair('Scheduler Date',item.schedularDate,),
                                    _pair(
                                      'Child Count',
                                      '${item.childCount}',
                                    ),
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _pair(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: Colors.grey.shade800,
            height: 1.25,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
