import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/seller_drawer_menu_button.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation_result.dart';
import 'package:tradologie_app/features/negotiation/domain/usecases/demo_negotiation_usecase.dart';
import 'package:tradologie_app/features/negotiation/presentation/cubit/negotiation_cubit.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:tradologie_app/injection_container.dart';

class DemoAuctionScreen extends StatefulWidget {
  final String title;
  final String description;
  final bool isDemoAuction;

  const DemoAuctionScreen({
    super.key,
    this.title = "Coming Soon",
    this.description =
        "This feature is under development and will be available soon.",
    this.isDemoAuction = false,
  });

  @override
  State<DemoAuctionScreen> createState() => _DemoAuctionScreenState();
}

class _DemoAuctionScreenState extends State<DemoAuctionScreen>
    with SingleTickerProviderStateMixin {
  NegotiationCubit get cubit => BlocProvider.of<NegotiationCubit>(context);

  Negotiation? negotiation;
  List<NegotiationResult>? negotiationData;
  int? expandedIndex;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isDemoAuction) {
      getDemoNegotiationData();
    }
  }

  Future<void> getDemoNegotiationData({int page = 0}) async {
    final secureStorage = SecureStorageService();
    final params = DemoNegotiationParams(
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      filterAuction: "",
      indexNo: page,
    );

    await cubit.demoNegotiationData(params);
    if (!mounted) return;
    setState(() {
      currentPage = page;
    });
  }

  void _openSupplierWebView(String? urlPath) {
    final finalUrl = "${EndPoints.supplierWebsiteurl}/${urlPath ?? ""}";
    if (Constants.isAndroid14OrBelow && Platform.isAndroid) {
      sl<NavigationService>().pushNamed(
        Routes.inAppWebViewRoute,
        arguments: WebviewParams(
          url: finalUrl,
          canPop: true,
          isAppBar: true,
        ),
      );
      return;
    }

    sl<NavigationService>().pushNamed(
      Routes.webViewRoute,
      arguments: WebviewParams(
        url: finalUrl,
        canPop: true,
        isAppBar: true,
      ),
    );
  }

  String _formatDateText(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return "-";
    }

    final parsed = DateTime.tryParse(rawDate);
    if (parsed != null) {
      return DateFormat('dd MMM yyyy').format(parsed);
    }

    final formats = [
      DateFormat('dd-MMM-yyyy HH:mm'),
      DateFormat('M/d/yyyy h:mm:ss a'),
    ];

    for (final format in formats) {
      try {
        final date = format.parse(rawDate);
        return DateFormat('dd MMM yyyy').format(date);
      } catch (_) {}
    }

    return rawDate;
  }

  Widget _detailRow({
    required String label,
    required String value,
    VoidCallback? onTap,
    TextStyle? valueStyle,
    Widget? trailingAction,
  }) {
    final defaultValueStyle = const TextStyle(fontSize: 13);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: (valueStyle ?? defaultValueStyle).copyWith(
                  decoration: onTap == null
                      ? (valueStyle?.decoration)
                      : (valueStyle?.decoration ?? TextDecoration.underline),
                ),
              ),
            ),
          ),
          if (trailingAction != null) trailingAction,
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = negotiation?.totalPages ?? 0;
    if (totalPages <= 0) return const SizedBox.shrink();

    final current = currentPage + 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _paginationBox("«",
            enabled: currentPage > 0,
            onTap: () => getDemoNegotiationData(page: 0)),
        const SizedBox(width: 8),
        _paginationBox("‹",
            enabled: currentPage > 0,
            onTap: () => getDemoNegotiationData(page: currentPage - 1)),
        const SizedBox(width: 8),
        _paginationBox(
          current.toString(),
          isActive: true,
          enabled: true,
          onTap: () => getDemoNegotiationData(page: current - 1),
        ),
        if (totalPages > 1) ...[
          const SizedBox(width: 8),
          _paginationBox("...", enabled: false),
          const SizedBox(width: 8),
          _paginationBox(
            totalPages.toString(),
            isActive: current == totalPages,
            enabled: true,
            onTap: () => getDemoNegotiationData(page: totalPages - 1),
          ),
          const SizedBox(width: 8),
        ] else ...[
          const SizedBox(width: 8),
        ],
        _paginationBox("›",
            enabled: currentPage < (totalPages - 1),
            onTap: () => getDemoNegotiationData(page: currentPage + 1)),
        const SizedBox(width: 8),
        _paginationBox("»",
            enabled: currentPage < (totalPages - 1),
            onTap: () => getDemoNegotiationData(page: totalPages - 1)),
      ],
    );
  }

  Widget _paginationBox(
    String text, {
    bool enabled = true,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF38A8F7) : const Color(0xFFE7EDF2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: enabled
                ? (isActive ? Colors.white : const Color(0xFF5C6B77))
                : const Color(0xFFB4BDC6),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDemoScreen() {
    return BlocConsumer<NegotiationCubit, NegotiationState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is DemoNegotiationSuccess) {
          setState(() {
            negotiation = state.data;
            negotiationData = state.data.detail;
          });
        }
      },
      buildWhen: (previous, current) {
        return current is DemoNegotiationIsLoading ||
            current is DemoNegotiationSuccess ||
            current is DemoNegotiationError;
      },
      builder: (context, state) {
        if (state is DemoNegotiationIsLoading) {
          return const CommonLoader();
        }
        if (state is DemoNegotiationError) {
          if (state.failure is NetworkFailure) {
            return CustomErrorNetworkWidget(
              onPress: () => getDemoNegotiationData(page: currentPage),
            );
          }
          return CustomErrorWidget(
            onPress: () => getDemoNegotiationData(page: currentPage),
            errorText: (state.failure is UserFailure)
                ? (state.failure as UserFailure).msg
                : "Something went wrong",
          );
        }

        final rows = negotiationData ?? [];

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0254CC),
                      Color(0xFF013897),
                    ],
                  ),
                ),
              ),
              leading: Navigator.canPop(context)
                  ? IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : const SellerDrawerMenuButton(
                      iconColor: Colors.white,
                      iconSize: 22,
                    ),
              title: const Text(
                "Negotiation Demo",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    sl<NavigationService>()
                        .pushNamed(Routes.notificationScreen);
                  },
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 15),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 5,
                      child: Text(
                        "Negotiation Code",
                        style: TextStyle(
                          color: Color(0xFF1B5AB2),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Status",
                        style: TextStyle(
                          color: Color(0xFF1B5AB2),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Date",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1B5AB2),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 500,
                      child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                  final row = rows[index];
                  final expanded = expandedIndex == index;
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAF1FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                expandedIndex = expanded ? null : index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: GestureDetector(
                                      onTap: () => _openSupplierWebView(
                                          row.navigateViewUrl),
                                      child: Text(
                                        row.auctionCode ?? '-',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (row.linkType == "directlink" &&
                                            (row.orderStatus ?? "")
                                                    .toLowerCase() ==
                                                "update rate") {
                                          _openSupplierWebView(row.navigateUrl);
                                        }
                                      },
                                      child: Text(
                                        row.orderStatus ?? '-',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF1B5AB2),
                                          decoration: TextDecoration.underline,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      _formatDateText(row.startDate),
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF1F6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: AnimatedRotation(
                                      turns: expanded ? .5 : 0,
                                      duration:
                                          const Duration(milliseconds: 220),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFF38A4F9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (expanded)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(height: 1),
                                  const SizedBox(height: 10),
                                  _detailRow(
                                    label: "Negotiation Code",
                                    value: row.auctionCode ?? '-',
                                    trailingAction: TextButton(
                                      onPressed: () =>
                                          _openSupplierWebView(row.navigateViewUrl),
                                      child: const Text(
                                        "View Details",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _detailRow(
                                      label: "Negotiation Name",
                                      value: row.auctionName ?? '-'),
                                  _detailRow(
                                    label: "Order Status",
                                    value: row.orderStatus ?? '-',
                                    onTap: (row.linkType == "directlink" &&
                                            (row.orderStatus ?? "")
                                                    .toLowerCase() ==
                                                "update rate")
                                        ? () => _openSupplierWebView(row.navigateUrl)
                                        : null,
                                    valueStyle: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xFF1B5AB2),
                                    ),
                                  ),
                                  _detailRow(
                                      label: "Start Date",
                                      value: _formatDateText(row.startDate)),
                                  _detailRow(
                                      label: "End Date",
                                      value: _formatDateText(row.endDate)),
                                  _detailRow(
                                      label: "Preferred Date",
                                      value: _formatDateText(row.preferredDate)),
                                  _detailRow(
                                      label: "Enquiry Status",
                                      value: row.isStarted == true
                                          ? "Started"
                                          : row.isclosed == true
                                              ? "Closed"
                                              : '-'),
                                  _detailRow(
                                      label: "Total Quantity",
                                      value: row.totalQuantity ?? '-'),
                                  _detailRow(
                                      label: "Minimum Quantity",
                                      value: row.minQuantity ?? '-'),
                                  _detailRow(
                                      label: "Participate Quantity",
                                      value: row.participateQuantity ?? '-'),
                                  _detailRow(
                                      label: "Last Date of Delivery",
                                      value:
                                          _formatDateText(row.deliveryLastDate)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                      child: _buildPagination(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isDemoAuction) {
      return AdaptiveScaffold(body: _buildDemoScreen());
    }

    return AdaptiveScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.description,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
