import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

class FmcgProductsScreen extends StatefulWidget {
  final String brandId;
  const FmcgProductsScreen({super.key, required this.brandId});

  @override
  State<FmcgProductsScreen> createState() => _FmcgProductsScreenState();
}

class _FmcgProductsScreenState extends State<FmcgProductsScreen> {
  List<GetProductsList>? productsList;

  SecureStorageService secureStorage = SecureStorageService();

  ChatCubit get chatCubit => BlocProvider.of(context);

  void getProductsList({
    String search = "",
  }) async {
    GetProductsListParams params = GetProductsListParams(
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      deviceId: Constants.deviceID,
      brandId: widget.brandId,
    );
    await chatCubit.getProductsList(params);
  }

  @override
  void initState() {
    super.initState();
    getProductsList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshChats() async => getProductsList();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is ProductsListSuccess) {
            setState(() => productsList = state.data);
          }
          if (state is ProductsListError) {
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
                          title: 'Product Catalogue',
                          showBackButton: true,
                          showNotification: false,
                        ),

                        SliverToBoxAdapter(
                          child: const SizedBox(height: 16),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => productCard(
                                productsList?[i] ?? GetProductsList(),
                              ),
                              childCount: productsList?.length ?? 0,
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
                  if (state is ProductsListIsLoading) {
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

  Widget productCard(GetProductsList enquiry) {
    return SizedBox.expand(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🖼️ PRODUCT IMAGE
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: enquiry.productImageUrl ?? "",
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// 🏷️ TITLE
              Text(
                enquiry.productName ?? "—",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2B2B2B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
