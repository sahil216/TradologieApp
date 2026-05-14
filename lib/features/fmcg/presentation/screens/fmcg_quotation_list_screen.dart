import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_query_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_quotation_tran_screen.dart';

class FmcgQuotationListScreen extends StatefulWidget {
  const FmcgQuotationListScreen({super.key});

  @override
  State<FmcgQuotationListScreen> createState() =>
      _FmcgQuotationListScreenState();
}

class _FmcgQuotationListScreenState extends State<FmcgQuotationListScreen> {
  final SecureStorageService _secureStorage = SecureStorageService();

  /// API uses 0-based page index (IndexNo).
  int _indexNo = 0;

  FmcgQuotationListSuccess? _cached;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch(_indexNo));
  }

  Future<void> _fetch(int indexNo) async {
    if (!mounted) return;
    setState(() => _indexNo = indexNo);

    final token =
        await _secureStorage.read(AppStrings.apiVerificationCode) ?? '';
    final loginIdStr = await _secureStorage.read(AppStrings.loginId) ?? '0';
    final userId = int.tryParse(loginIdStr) ?? 0;

    if (!mounted) return;
    context.read<ChatCubit>().getFmcgQuotationList(
          ChatbotQueryListParams(
            token: token,
            deviceId: Constants.deviceID,
            userId: userId,
            indexNo: indexNo,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (p, c) =>
          c is FmcgQuotationListSuccess ||
          c is FmcgQuotationListError ||
          c is FmcgQuotationListLoading,
      listener: (context, state) {
        if (state is FmcgQuotationListSuccess) {
          _cached = state;
        }
        if (state is FmcgQuotationListError) {
          CommonToast.showFailureToast(state.failure);
        }
      },
      buildWhen: (p, c) =>
          c is FmcgQuotationListLoading ||
          c is FmcgQuotationListSuccess ||
          c is FmcgQuotationListError ||
          c is ChatInitial,
      builder: (context, state) {
        final loading = state is FmcgQuotationListLoading;
        final data = state is FmcgQuotationListSuccess ? state : _cached;
        final items = data?.items ?? <FmcgQuotationListItem>[];
        final totalPages = data?.totalPages ?? 1;
        final totalRecords = data?.totalRecords ?? 0;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    CommonAppbar(
                      title: 'Quotation List',
                      showBackButton: true,
                      showNotification: false,
                    ),
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
                            child: CommonText(
                              'No quotations found',
                              style: TextStyleConstants.medium(
                                context,
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        )
                      else if (items.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final e = items[i];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: i < items.length - 1 ? 12 : 0,
                                  ),
                                  child: _QuotationCard(
                                    item: e,
                                    onTap: () async {
                                      final token = await _secureStorage.read(
                                            AppStrings.apiVerificationCode,
                                          ) ??
                                          '';
                                      if (!context.mounted) return;
                                      context
                                          .read<ChatCubit>()
                                          .getFmcgQuotationTranList(
                                            QuotationTranListParams(
                                              token: token,
                                              deviceId: Constants.deviceID,
                                              quotationId: e.quotationId,
                                            ),
                                          );
                                      if (!context.mounted) return;
                                      Navigator.of(context).pushNamed(
                                        Routes.fmcgQuotationTranScreen,
                                        arguments: FmcgQuotationTranScreenArgs(
                                          quotationId: e.quotationId,
                                          quotationNo: e.quotationNo,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              childCount: items.length,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
              if (data != null && totalPages > 1)
                _paginationBar(
                  totalPages: totalPages,
                  totalRecords: totalRecords,
                ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
            ],
          ),
        );
      },
    );
  }

  Widget _paginationBar({
    required int totalPages,
    required int totalRecords,
  }) {
    final canPrev = _indexNo > 0;
    final canNext = _indexNo < totalPages - 1;

    return Material(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            TextButton(
              onPressed: canPrev ? () => _fetch(_indexNo - 1) : null,
              child: const Text('Previous'),
            ),
            Expanded(
              child: Text(
                'Page ${_indexNo + 1} of $totalPages'
                '${totalRecords > 0 ? ' · $totalRecords total' : ''}',
                textAlign: TextAlign.center,
                style: TextStyleConstants.medium(context, fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: canNext ? () => _fetch(_indexNo + 1) : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuotationCard extends StatelessWidget {
  final FmcgQuotationListItem item;
  final VoidCallback onTap;

  const _QuotationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.receipt_long_outlined,
                    color: Colors.blue.shade700, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        item.quotationNo,
                        style: TextStyleConstants.semiBold(
                          context,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CommonText(
                        item.quotationStatusName,
                        style: TextStyleConstants.medium(
                          context,
                          fontSize: 13,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _row(context, 'Buyer', item.buyerName),
            _row(context, 'Mobile', item.buyerMobile),
            if (item.buyerEmail.isNotEmpty)
              _row(context, 'Email', item.buyerEmail),
            _row(context, 'Date', item.quotationDate),
            _row(context, 'Brand', item.brandName),
          ],
        ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: CommonText(
              label,
              style: TextStyleConstants.semiBold(context, fontSize: 13),
            ),
          ),
          Expanded(
            child: CommonText(
              value.isEmpty ? '—' : value,
              style: TextStyleConstants.regular(context, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
