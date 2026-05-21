import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_no_record_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/features/app/presentation/cubit/app_cubit.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation_result.dart';
import 'package:tradologie_app/features/negotiation/presentation/cubit/negotiation_cubit.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/negotiation.dart';
import '../../domain/usecases/get_negotiation_usecase.dart';

class NegotiationScreen extends StatefulWidget {
  const NegotiationScreen({
    super.key,
  });

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen>
    with SingleTickerProviderStateMixin {
  Negotiation? negotiation;
  List<NegotiationResult>? negotiationData;
  int? expandedIndex;

  int currentPage = 0;

  NegotiationCubit get cubit => BlocProvider.of<NegotiationCubit>(context);
  late AppCubit _appCubit;

  @override
  void initState() {
    super.initState();
    getNegotiationData();
    _appCubit = BlocProvider.of<AppCubit>(context);

    // Force landscape
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
  }

  Future<void> getNegotiationData({int page = 0}) async {
    SecureStorageService secureStorage = SecureStorageService();
    GetNegotiationParams params = GetNegotiationParams(
        token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
        filterAuction: '',
        vendorID: await secureStorage.read(AppStrings.vendorId) ?? "",
        indexNo: page);

    await cubit.getNegotiationData(params);
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NegotiationCubit, NegotiationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is GetNegotiationSuccess) {
              setState(() {
                negotiationData?.clear();
                negotiation = state.data;
                negotiationData = state.data.detail;
              });
            }
            if (state is GetNegotiationError) {
              // Constants.showFailureToast(state.failure);
            }
          },
        ),
        BlocListener<AppCubit, AppState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {},
        ),
      ],
      child: AdaptiveScaffold(
          // appBar: Constants.appBar(context,
          //     title: 'Negotiation',
          //     centerTitle: true,
          //     // titleWidget: Row(
          //     //   children: [
          //     //     Image.asset(ImgAssets.companyLogo, height: 40),
          //     //     Spacer(),
          //     //    CommonText(
          //     //       'Negotiation',
          //     //       style: TextStyleConstants.bold(context,
          //     //           color: AppColors.defaultText),
          //     //     ),
          //     //     SizedBox(width: 30),
          //     //   ],
          //     // ),
          //     actions: [
          //       IconButton(
          //           onPressed: () {
          //             sl<NavigationService>().pushNamed(
          //               Routes.notificationScreen,
          //             );
          //           },
          //           icon: Icon(Icons.notifications)),
          //       SizedBox(width: 10),
          //     ]),
          body: BlocBuilder<NegotiationCubit, NegotiationState>(
            buildWhen: (previous, current) {
              bool result = previous != current;
              result = result &&
                  (current is GetNegotiationSuccess ||
                      current is GetNegotiationError ||
                      current is GetNegotiationIsLoading);
              return result;
            },
            builder: (context, state) {
              if (state is GetNegotiationIsLoading) {
                return const CommonLoader();
              }
              if (state is GetNegotiationError) {
                if (state.failure is NetworkFailure) {
                  return CustomErrorNetworkWidget(
                    onPress: () {
                      getNegotiationData();
                    },
                  );
                } else if (state.failure is UserFailure) {
                  if (state.failure.msg?.toLowerCase() == "no record found!") {
                    return CommonNoRecordWidget(
                      onTap: () {
                        _appCubit.changeTab(2);
                      },
                      text:
                          "No negotiations are assigned to your account, please get verified your account. If you need any assistance, contact us at info@tradologie.com or call us at +91-8595957412",
                      buttonText: "Update your Profile",
                    );
                  } else {
                    return CustomErrorWidget(
                      onPress: () {
                        getNegotiationData();
                      },
                      errorText: state.failure.msg,
                    );
                  }
                }
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
                            Color(0xCC0254CC),
                            Color(0xCC013897),
                          ],
                        ),
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    title: Text(
                      "Negotiation List",
                     /* style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                      ),*/



                      style: GoogleFonts.dmSans(

                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18, // 👈 add it here
                      ),

                    ),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        onPressed: () {
                          sl<NavigationService>().pushNamed(
                            Routes.notificationScreen,
                          );
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
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              "Negotiation Code",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.dmSans(
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
                              textAlign: TextAlign.start,
                              style: GoogleFonts.dmSans(
                                color: Color(0xFF1B5AB2),
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Start Date",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
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
                                            expandedIndex =
                                                expanded ? null : index;
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
                                                  onTap: () {
                                                    _openSupplierWebView(
                                                        row.navigateViewUrl);
                                                  },
                                                  child: CommonText(
                                                    row.auctionCode ?? '-',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.dmSans(

                                                      color: Color(0xFF222222),
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13, // 👈 add it here
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (row.linkType ==
                                                            "directlink" &&
                                                        row.orderStatus
                                                                ?.toLowerCase() ==
                                                            "update rate") {
                                                      _openSupplierWebView(
                                                          row.navigateUrl);
                                                    }
                                                  },
                                                  child: Text(
                                                    row.orderStatus ?? '-',
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,

                                                    style: GoogleFonts.dmSans(

                                                      color: Color(0xFF1B5AB2),
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13, // 👈 add it here
                                                    ),

                                                   /* style: TextStyleConstants
                                                        .regular(
                                                      context,
                                                      fontSize: 14,
                                                      color: AppColors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),*/
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  row.startDate ?? " ",
                                                  textAlign: TextAlign.end,

                                                  // gopal


                                                  style: GoogleFonts.dmSans(

                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12, // 👈 add it here
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                width: 26,
                                                height: 26,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFEAF1F6),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: AnimatedRotation(
                                                  turns: expanded ? .5 : 0,
                                                  duration: const Duration(
                                                      milliseconds: 220),
                                                  child: const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Divider(height: 1),
                                              const SizedBox(height: 10),
                                              _detail(
                                                "Negotiation Code ",
                                                row.auctionCode ?? '-',
                                                true,
                                                () {
                                                  _openSupplierWebView(
                                                      row.navigateViewUrl);
                                                },
                                              ),
                                              _detail(
                                                  "Negotiation Name ",
                                                  row.auctionName ?? '-',
                                                  false,
                                                  null),
                                              _detail(
                                                "Order Status ",
                                                row.orderStatus ?? '-',
                                                false,
                                                null,
                                                onTap: () {
                                                  if (row.linkType ==
                                                          "directlink" &&
                                                      row.orderStatus
                                                              ?.toLowerCase() ==
                                                          "update rate") {
                                                    _openSupplierWebView(
                                                        row.navigateUrl);
                                                  }
                                                },
                                              ),
                                              _detail(
                                                  "Start Date ",
                                                  row.startDate ??
                                                      "",
                                                  false,
                                                  null),
                                              _detail(
                                                  "End Date ",
                                                  row.endDate ??
                                                      "",
                                                  false,
                                                  null),
                                              _detail(
                                                  "Preferred Date ",
                                                  row.preferredDate ??
                                                      "",
                                                  false,
                                                  null),
                                              _detail(
                                                  "Enquiry Status ",
                                                  row.isStarted == true
                                                      ? "Started"
                                                      : row.isclosed == true
                                                          ? "Closed"
                                                          : '-',
                                                  false,
                                                  null),
                                              _detail("Total Quantity ",
                                                  row.totalQuantity ?? '-', false,
                                                  null),
                                              _detail("Minimum Quantity ",
                                                  row.minQuantity ?? '-', false,
                                                  null),
                                              _detail("Participate Quantity ",
                                                  row.participateQuantity ?? '-',
                                                  false, null),
                                              _detail(
                                                  "Last Date of Delivery ",
                                                  Constants.dateFormat(
                                                    DateTime.tryParse(
                                                            row.deliveryLastDate ??
                                                                "") ??
                                                        DateTime.now(),
                                                  ),
                                                  false,
                                                  null),
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
                            padding: const EdgeInsets.fromLTRB(14, 15, 14, 12),
                            child: _buildPagination(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: const SizedBox(
            height: 70,
          )),
    );
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

  Widget _buildPagination() {
    final totalPages = negotiation?.totalPages ?? 0;
    if (totalPages <= 0) {
      return const SizedBox.shrink();
    }

    final current = currentPage + 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _paginationBox("«",
            enabled: currentPage > 0, onTap: () => getNegotiationData(page: 0)),
        const SizedBox(width: 8),
        _paginationBox("‹",
            enabled: currentPage > 0,
            onTap: () => getNegotiationData(page: currentPage - 1)),
        const SizedBox(width: 8),
        _paginationBox(
          current.toString(),
          isActive: true,
          enabled: true,
          onTap: () => getNegotiationData(page: current - 1),
        ),
        if (totalPages > 1) ...[
          const SizedBox(width: 8),
          _paginationBox("...", enabled: false),
          const SizedBox(width: 8),
          _paginationBox(
            totalPages.toString(),
            isActive: current == totalPages,
            enabled: true,
            onTap: () => getNegotiationData(page: totalPages - 1),
          ),
          const SizedBox(width: 8),
        ] else ...[
          const SizedBox(width: 8),
        ],
        _paginationBox("›",
            enabled: currentPage < (totalPages - 1),
            onTap: () => getNegotiationData(page: currentPage + 1)),
        const SizedBox(width: 8),
        _paginationBox("»",
            enabled: currentPage < (totalPages - 1),
            onTap: () => getNegotiationData(page: totalPages - 1)),
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
        width: 40,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF38A8F7) : const Color(0xFFE7EDF2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: enabled
                ? (isActive ? Colors.white : const Color(0xFF5C6B77))
                : const Color(0xFFB4BDC6),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _detail(
      String title, String value, bool isShowView, VoidCallback? onViewTap,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title,
              style: TextStyleConstants.semiBold(context, fontSize: 13)),
          GestureDetector(
            onTap: onTap,
            child: CommonText(
              value,
              style: TextStyleConstants.regular(context,
                  fontSize: 13,
                  decoration: onTap == null ? null : TextDecoration.underline),
            ),
          ),
          isShowView == true
              ? GestureDetector(
                  onTap: onViewTap,
                  child: CommonText("View Details",
                      style: TextStyleConstants.medium(context,
                          fontSize: 14, decoration: TextDecoration.underline)),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
