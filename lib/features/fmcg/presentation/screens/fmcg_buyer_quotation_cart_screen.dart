import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/buyer_quotation_item.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_quotation_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/delete_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_quotation_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

class FmcgBuyerQuotationCartArgs {
  final int brandId;
  final String brandName;

  const FmcgBuyerQuotationCartArgs({
    required this.brandId,
    required this.brandName,
  });
}



class FmcgBuyerQuotationCartScreen extends StatefulWidget {
  final FmcgBuyerQuotationCartArgs args;

  const FmcgBuyerQuotationCartScreen({super.key, required this.args});

  @override
  State<FmcgBuyerQuotationCartScreen> createState() =>
      _FmcgBuyerQuotationCartScreenState();
}

class _FmcgBuyerQuotationCartScreenState
    extends State<FmcgBuyerQuotationCartScreen> {
  final SecureStorageService _secureStorage = SecureStorageService();
  List<BuyerQuotationItem>? _cached;
  final Set<int> _selectedQuotationIds = <int>{};
  final Set<int> _deletingQuotationIds = <int>{};
  final Map<int, int> _qtyByQuotationId = <int, int>{};

  int _minQtyFor(BuyerQuotationItem item) {
    final min = item.minOrderQuantity <= 0 ? 1 : item.minOrderQuantity;
    return min;
  }

  int _effectiveQtyFor(BuyerQuotationItem item) {
    final min = _minQtyFor(item);
    final raw = _qtyByQuotationId[item.quotationId] ?? item.quantity;
    if (raw <= 0) return min;
    return raw < min ? min : raw;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() async {
    final token = await _secureStorage.read(AppStrings.apiVerificationCode) ?? '';
    final buyerIdStr = await _secureStorage.read(AppStrings.loginId) ?? '0';
    final buyerId = int.tryParse(buyerIdStr) ?? 0;

    if (!mounted) return;
    context.read<ChatCubit>().getBuyerQuotationList(
          GetBuyerQuotationListParams(
            token: token,
            deviceId: Constants.deviceID,
            brandId: widget.args.brandId,
            buyerId: buyerId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (p, c) =>
          c is BuyerQuotationListSuccess ||
          c is BuyerQuotationListError ||
          c is DeleteQuotationCartSuccess ||
          c is DeleteQuotationCartError ||
          c is AddBuyerQuotationSuccess ||
          c is AddBuyerQuotationError,
      listener: (context, state) {
        if (state is BuyerQuotationListSuccess) {
          _cached = state.items;
        }
        if (state is BuyerQuotationListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.msg ?? 'Error')),
          );
        }
        if (state is DeleteQuotationCartSuccess) {
          _deletingQuotationIds.remove(state.quotationId);
          _selectedQuotationIds.remove(state.quotationId);
          _cached = (_cached ?? const <BuyerQuotationItem>[])
              .where((e) => e.quotationId != state.quotationId)
              .toList();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          setState(() {});
        }
        if (state is DeleteQuotationCartError) {
          _deletingQuotationIds.remove(state.quotationId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.msg ?? 'Error')),
          );
          setState(() {});
        }
        if (state is AddBuyerQuotationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          _selectedQuotationIds.clear();
          _qtyByQuotationId.clear();
          _fetch();
        }
        if (state is AddBuyerQuotationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.msg ?? 'Error')),
          );
        }
      },
      buildWhen: (p, c) =>
          c is BuyerQuotationListLoading ||
          c is BuyerQuotationListSuccess ||
          c is BuyerQuotationListError ||
          c is DeleteQuotationCartLoading ||
          c is AddBuyerQuotationLoading ||
          c is ChatInitial,
      builder: (context, state) {
        final loading = state is BuyerQuotationListLoading;
        final items = state is BuyerQuotationListSuccess ? state.items : _cached;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          bottomNavigationBar: _selectedQuotationIds.isEmpty
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AddBuyerQuotationLoading
                          ? null
                          : () async {
                              final token = await _secureStorage.read(
                                      AppStrings.apiVerificationCode) ??
                                  '';
                              final buyerIdStr =
                                  await _secureStorage.read(AppStrings.loginId) ??
                                      '0';
                              final buyerId = int.tryParse(buyerIdStr) ?? 0;
                              final list = items ?? _cached ?? <BuyerQuotationItem>[];
                              final selected = list
                                  .where((e) => _selectedQuotationIds.contains(e.quotationId))
                                  .toList();
                              if (selected.isEmpty) return;
                              if (!context.mounted) return;
                              context.read<ChatCubit>().addBuyerQuotation(
                                    AddBuyerQuotationParams(
                                      token: token,
                                      deviceId: Constants.deviceID,
                                      brandId: widget.args.brandId,
                                      buyerId: buyerId,
                                      tranQuotation: selected
                                          .map(
                                            (e) => TranQuotationItem(
                                              tranId: e.quotationId,
                                              quantity: _effectiveQtyFor(e),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A4FD6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit Quotation (${_selectedQuotationIds.length})',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              CommonAppbar(
                title: 'Quotation Cart',
                showBackButton: true,
                showNotification: false,
              ),
              if (loading && items == null)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if ((items ?? const <BuyerQuotationItem>[]).isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No items found',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final e = items![i];
                        final isSelected =
                            _selectedQuotationIds.contains(e.quotationId);
                        final isDeleting =
                            _deletingQuotationIds.contains(e.quotationId) ||
                                (state is DeleteQuotationCartLoading &&
                                    state.quotationId == e.quotationId);
                        final effectiveQty = _effectiveQtyFor(e);
                        final minQty = _minQtyFor(e);
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i < items.length - 1 ? 12 : 0,
                          ),
                          child: _BuyerQuotationItemCard(
                            item: e,
                            selected: isSelected,
                            deleting: isDeleting,
                            qty: effectiveQty,
                            minQty: minQty,
                            onSelectedChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedQuotationIds.add(e.quotationId);
                                } else {
                                  _selectedQuotationIds.remove(e.quotationId);
                                }
                              });
                            },
                            onDecreaseQty: () {
                              setState(() {
                                final next =
                                    (_qtyByQuotationId[e.quotationId] ??
                                            e.quantity) -
                                        1;
                                _qtyByQuotationId[e.quotationId] =
                                    next < minQty ? minQty : next;
                              });
                            },
                            onIncreaseQty: () {
                              setState(() {
                                final next =
                                    (_qtyByQuotationId[e.quotationId] ??
                                            e.quantity) +
                                        1;
                                _qtyByQuotationId[e.quotationId] = next;
                              });
                            },
                            onDeletePressed: () async {
                              if (_deletingQuotationIds
                                  .contains(e.quotationId)) {
                                return;
                              }
                              final token = await _secureStorage.read(
                                      AppStrings.apiVerificationCode) ??
                                  '';
                              if (!context.mounted) return;
                              setState(() {
                                _deletingQuotationIds.add(e.quotationId);
                              });
                              context.read<ChatCubit>().deleteQuotationCart(
                                    DeleteQuotationCartParams(
                                      token: token,
                                      deviceId: Constants.deviceID,
                                      quotationId: e.quotationId,
                                    ),
                                  );
                            },
                          ),
                        );
                      },
                      childCount: items?.length ?? 0,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BuyerQuotationItemCard extends StatelessWidget {
  final BuyerQuotationItem item;
  final bool selected;
  final ValueChanged<bool?> onSelectedChanged;
  final VoidCallback onDeletePressed;
  final bool deleting;
  final int qty;
  final int minQty;
  final VoidCallback onDecreaseQty;
  final VoidCallback onIncreaseQty;

  const _BuyerQuotationItemCard({
    required this.item,
    required this.selected,
    required this.onSelectedChanged,
    required this.onDeletePressed,
    required this.deleting,
    required this.qty,
    required this.minQty,
    required this.onDecreaseQty,
    required this.onIncreaseQty,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Checkbox(
                value: selected,
                onChanged: onSelectedChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.productImageUrl,
                width: 74,
                height: 74,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 74,
                  height: 74,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 74,
                  height: 74,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName.isEmpty ? '—' : item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip(
                        '${item.attributeType1Name.isEmpty ? 'Attr1' : item.attributeType1Name}: ${item.attributeValue1Name.isEmpty ? '—' : item.attributeValue1Name}',
                      ),
                      _chip(
                        '${item.attributeType2Name.isEmpty ? 'Attr2' : item.attributeType2Name}: ${item.attributeValue2Name.isEmpty ? '—' : item.attributeValue2Name}',
                      ),
                      _qtyPill(context),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Min order & Added hidden as requested
                ],
              ),
            ),
            IconButton(
              onPressed: deleting ? null : onDeletePressed,
              icon: deleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3A4FD6),
        ),
      ),
    );
  }

  Widget _qtyPill(BuildContext context) {
    final canDecrease = qty > minQty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: canDecrease ? onDecreaseQty : null,
            icon: const Icon(Icons.remove, size: 16),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
          const SizedBox(width: 4),
          Text(
            '$qty',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Color(0xFF3A4FD6),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onIncreaseQty,
            icon: const Icon(Icons.add, size: 16),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }
}

