import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_tran_item.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

class FmcgQuotationTranScreenArgs {
  final int quotationId;
  final String quotationNo;

  const FmcgQuotationTranScreenArgs({
    required this.quotationId,
    required this.quotationNo,
  });
}

/// Line items for a single quotation (QuotationTranList API).
class FmcgQuotationTranScreen extends StatefulWidget {
  final FmcgQuotationTranScreenArgs args;

  const FmcgQuotationTranScreen({super.key, required this.args});

  @override
  State<FmcgQuotationTranScreen> createState() =>
      _FmcgQuotationTranScreenState();
}

class _FmcgQuotationTranScreenState extends State<FmcgQuotationTranScreen> {
  final SecureStorageService _secureStorage = SecureStorageService();
  List<FmcgQuotationTranItem>? _cached;

  @override
  void initState() {
    super.initState();
    // Trigger API call immediately when screen is created.
    _load();
  }

  Future<void> _load() async {
    final token =
        await _secureStorage.read(AppStrings.apiVerificationCode) ?? '';
    if (!mounted) return;
    context.read<ChatCubit>().getFmcgQuotationTranList(
          QuotationTranListParams(
            token: token,
            deviceId: Constants.deviceID,
            quotationId: widget.args.quotationId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (p, c) =>
          c is FmcgQuotationTranListSuccess ||
          c is FmcgQuotationTranListError ||
          c is FmcgQuotationTranListLoading,
      listener: (context, state) {
        if (state is FmcgQuotationTranListSuccess) {
          _cached = state.items;
        }
        if (state is FmcgQuotationTranListError) {
          CommonToast.showFailureToast(state.failure);
        }
      },
      buildWhen: (p, c) =>
          c is FmcgQuotationTranListLoading ||
          c is FmcgQuotationTranListSuccess ||
          c is FmcgQuotationTranListError ||
          c is ChatInitial,
      builder: (context, state) {
        final loading = state is FmcgQuotationTranListLoading;
        final items = state is FmcgQuotationTranListSuccess
            ? state.items
            : (_cached ?? <FmcgQuotationTranItem>[]);

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
                      title: widget.args.quotationNo,
                      showBackButton: true,
                      showNotification: false,
                    ),
                    if (loading && _cached == null)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      if (loading && _cached != null)
                        const SliverToBoxAdapter(
                          child: LinearProgressIndicator(minHeight: 2),
                        ),
                      if (!loading && items.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CommonText(
                              'No line items',
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
                                  child: _LineItemCard(item: e),
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
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
            ],
          ),
        );
      },
    );
  }
}

class _LineItemCard extends StatelessWidget {
  final FmcgQuotationTranItem item;

  const _LineItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final attrs = [
      if (item.attributeValueName1.isNotEmpty) item.attributeValueName1,
      if (item.attributeValueName2.isNotEmpty) item.attributeValueName2,
    ].join(' · ');

    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(14),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.inventory_2_outlined,
                    color: Colors.teal.shade700, size: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        item.productName,
                        style: TextStyleConstants.semiBold(
                          context,
                          fontSize: 15,
                        ),
                      ),
                      if (attrs.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        CommonText(
                          attrs,
                          style: TextStyleConstants.regular(
                            context,
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _row(context, 'Quantity', item.quantity),
            _row(
              context,
              'Quoted rate',
              item.quotedRate == 0 ? '—' : item.quotedRate.toString(),
            ),
            _row(
              context,
              'Counter offer',
              item.counterOfferRate == 0 ? '—' : item.counterOfferRate.toString(),
            ),
            if (item.counterOfferAccepted.isNotEmpty &&
                item.counterOfferAccepted != '0')
              _row(context, 'Counter accepted', item.counterOfferAccepted),
            _row(context, 'Status', item.quotationStatus),
          ],
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
            width: 110,
            child: CommonText(
              label,
              style: TextStyleConstants.semiBold(context, fontSize: 12),
            ),
          ),
          Expanded(
            child: CommonText(
              value.isEmpty ? '—' : value,
              style: TextStyleConstants.regular(context, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
