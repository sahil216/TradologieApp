import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/app/presentation/widgets/auto_refresh_mixin.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/buyer_negotitation_detail.dart';
import 'package:tradologie_app/features/negotiation/presentation/cubit/negotiation_cubit.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/buyer_negotiation.dart';
import '../../domain/usecases/get_negotiation_usecase.dart';

class BuyerNegotiationScreen extends StatefulWidget {
  const BuyerNegotiationScreen({super.key});

  @override
  State<BuyerNegotiationScreen> createState() => _BuyerNegotiationScreenState();
}

class _BuyerNegotiationScreenState extends State<BuyerNegotiationScreen> {
  BuyerNegotiation? negotiation;
  List<BuyerNegotiationDetail>? negotiationData;

  final ScrollController _headerController = ScrollController();
  final ScrollController _bodyController = ScrollController();

  final double defaultColumnWidth = 150;

  int? expandedIndex;

  int currentPage = 0;
  int pageSize = 20;

  final List<String> headers = [
    // 'S.No.',
    'Negotiation Code',
    // 'Negotiation Name',
    'Order Status',
    // 'Delivery Address',
    // 'Delivery State',
    // 'Payment Term',
    // 'Partial Delivery',
    'Status',
    // 'Enquiry Status',
  ];

  final Map<String, double> columnWidths = {
    // 'S.No.': 100,
    'Negotiation Code': 200,
    // 'Negotiation Name': 250,
    'Order Status': 150,
    // 'Delivery Address': 300,
    // 'Delivery State': 200,
    // 'Payment Term': 150,
    // 'Partial Delivery': 200,
    'Status': 100,
    // 'Enquiry Status': 200,
  };

  NegotiationCubit get cubit => BlocProvider.of<NegotiationCubit>(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await SystemChrome.setPreferredOrientations([
      //   DeviceOrientation.landscapeLeft,
      //   DeviceOrientation.landscapeRight,
      // ]);
    });
    getNegotiationData();

    // Sync horizontal scroll
    _bodyController.addListener(() {
      if (_headerController.offset != _bodyController.offset) {
        _headerController.jumpTo(_bodyController.offset);
      }
    });
  }

  @override
  void dispose() {
    // Restore portrait
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.portraitUp,
    // ]);
    _headerController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> getNegotiationData({int page = 0}) async {
    SecureStorageService secureStorage = SecureStorageService();
    GetNegotiationParams params = GetNegotiationParams(
        token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
        filterAuction: '',
        vendorID: "",
        customerID: await secureStorage.read(AppStrings.customerId) ?? "",
        indexNo: page);

    await cubit.buyerNegotiationData(params);
    setState(() {
      currentPage = page;
    });
  }

  /// Total table width based on custom column widths
  double getTableWidth() {
    return headers.fold<double>(
        0, (sum, header) => sum + (columnWidths[header] ?? defaultColumnWidth));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NegotiationCubit, NegotiationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is BuyerNegotiationSuccess) {
              setState(() {
                negotiationData?.clear();
                negotiation = state.data;
                negotiationData = state.data.detail;
              });
            }
            if (state is BuyerNegotiationError) {
              CommonToast.showFailureToast(state.failure);
            }
          },
        ),
      ],
      child: AdaptiveScaffold(
        drawer: const TradologieDrawer(),
        appBar: Constants.appBar(context,
            title: 'Negotiation',
            centerTitle: true,
            // titleWidget: Row(
            //   children: [
            //     Image.asset(ImgAssets.companyLogo, height: 40),
            //     Spacer(),
            //     Text(
            //       'Negotiation',
            //       style: TextStyleConstants.bold(context,
            //           color: AppColors.defaultText),
            //     ),
            //     SizedBox(width: 30),
            //   ],
            // ),
            actions: [
              IconButton(
                  onPressed: () {
                    sl<NavigationService>().pushNamed(
                      Routes.notificationScreen,
                    );
                  },
                  icon: Icon(Icons.notifications)),
              SizedBox(width: 10),
            ]),
        body: BlocBuilder<NegotiationCubit, NegotiationState>(
            buildWhen: (previous, current) {
          bool result = previous != current;
          result = result &&
              (current is BuyerNegotiationSuccess ||
                  current is BuyerNegotiationError ||
                  current is BuyerNegotiationIsLoading);
          return result;
        }, builder: (context, state) {
          if (state is BuyerNegotiationIsLoading) {
            return const CommonLoader();
          }
          if (state is BuyerNegotiationError) {
            if (state.failure is NetworkFailure) {
              return CustomErrorNetworkWidget(
                onPress: () {
                  getNegotiationData();
                },
              );
            } else if (state.failure is UserFailure) {
              return CustomErrorWidget(
                onPress: () {
                  getNegotiationData();
                },
                errorText: state.failure.msg,
              );
            }
          }

          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                // 🔹 Header
                CommonSingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _headerController,
                  child: Row(
                    children: headers.map((header) {
                      return _cell(
                        header,
                        width: columnWidths[header] ?? defaultColumnWidth,
                        isHeader: true,
                      );
                    }).toList(),
                  ),
                ),

                // 🔹 Body
                Expanded(
                  child: CommonSingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _bodyController,
                    child: SizedBox(
                      width: getTableWidth(),
                      child: ListView.builder(
                        itemCount: negotiationData?.length ?? 0,
                        itemBuilder: (context, rowIndex) {
                          final row = negotiationData![rowIndex];
                          bool expanded = expandedIndex == rowIndex;
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expandedIndex =
                                          expanded ? null : rowIndex;
                                    });
                                  },
                                  child: Row(
                                    children: headers.map((header) {
                                      if (header == 'Negotiation Code') {
                                        return Container(
                                          width: 200,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AnimatedRotation(
                                                turns: expanded ? 0.5 : 0,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                child: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                _getCellText(row, header),
                                                style:
                                                    TextStyleConstants.regular(
                                                  context,
                                                  fontSize: 16,
                                                  color: row.auctionColorCode ==
                                                          "red"
                                                      ? AppColors.red
                                                      : AppColors.defaultText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return _cell(
                                        _getCellText(row, header),
                                        width: columnWidths[header] ??
                                            defaultColumnWidth,
                                        isUnderline: header.toLowerCase() ==
                                            'order status',
                                        color: row.auctionColorCode == "red"
                                            ? AppColors.red
                                            : AppColors.black,
                                        onTap: () {
                                          if (header.toLowerCase() ==
                                                  'order status' &&
                                              row.auctionStatus
                                                      ?.toLowerCase() ==
                                                  "view rate") {
                                            Constants.isAndroid14OrBelow &&
                                                    Platform.isAndroid
                                                ? Navigator.pushNamed(context,
                                                    Routes.inAppWebViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.buyerUrlWeb}${row.auctionUrl}",
                                                        canPop: true,
                                                        isAppBar: true))
                                                : Navigator.pushNamed(
                                                    context, Routes.webViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.buyerUrlWeb}${row.auctionUrl}",
                                                        canPop: true,
                                                        isAppBar: true));
                                          } else if (header.toLowerCase() ==
                                              'negotiation code') {
                                            // Navigator.pushNamed(
                                            //     context, Routes.webViewRoute,
                                            //     arguments: WebviewParams(
                                            //         url:
                                            //             "${EndPoints.buyerUrlWeb}${row.auctionCodeUrl}",
                                            //         canPop: true,
                                            //         isAppBar: true));
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                ClipRect(
                                  child: Align(
                                    heightFactor: expanded ? 1 : 0,
                                    child: Container(
                                      width: getTableWidth(),
                                      padding: const EdgeInsets.all(16),
                                      color: Colors.grey.shade100,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _detail(
                                              "Negotiation Name ",
                                              row.auctionName ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Delivery Address",
                                              row.deliveryAddress ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Delivery State",
                                              row.deliveryState ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Payment Term",
                                              row.paymentTerm ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Partial Delivery",
                                              row.partialDelivery ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Enquiry Status",
                                              row.isStarted == true
                                                  ? "Started"
                                                  : row.isclosed == true
                                                      ? "Closed"
                                                      : 'Not Started',
                                              false,
                                              null),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0
                      ? () {
                          getNegotiationData(page: currentPage - 1);
                        }
                      : null,
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 20),
                Text(
                    'Page ${currentPage + 1} of ${negotiation?.totalPages ?? 0}'),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed:
                      ((currentPage + 1) < (negotiation?.totalPages ?? 0))
                          ? () {
                              getNegotiationData(page: currentPage + 1);
                            }
                          : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detail(
      String title, String value, bool isShowView, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyleConstants.semiBold(context, fontSize: 14)),
          Text(value, style: TextStyleConstants.regular(context, fontSize: 14)),
          isShowView == true
              ? GestureDetector(
                  onTap: onTap,
                  child: Text("View Details",
                      style: TextStyleConstants.medium(context,
                          fontSize: 14, decoration: TextDecoration.underline)),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  /// Individual cell
  Widget _cell(
    String text, {
    double width = 150,
    bool isHeader = false,
    bool isUnderline = false,
    Color? color,
    VoidCallback? onTap,
  }) {
    return Container(
      width: width,
      height: isHeader ? 50 : 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade300 : Colors.transparent,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: isHeader
              ? TextStyleConstants.semiBold(context, fontSize: 16)
              : TextStyleConstants.regular(context,
                  fontSize: 16,
                  color: color ?? AppColors.defaultText,
                  decoration: isUnderline ? TextDecoration.underline : null),
        ),
      ),
    );
  }

  /// Map row data to column text
  String _getCellText(BuyerNegotiationDetail row, String header) {
    switch (header) {
      case 'S.No.':
        return (negotiationData!.indexOf(row) + 1).toString();
      case 'Negotiation Code':
        return row.auctionCode ?? '-';
      case 'Negotiation Name':
        return row.auctionName ?? '-';
      case 'Order Status':
        return row.auctionStatus ?? '-';
      case 'Delivery Address':
        return row.deliveryAddress ?? '-';
      case 'Delivery State':
        return row.deliveryState ?? '-';
      case 'Payment Term':
        return row.paymentTerm ?? '-';
      case 'Partial Delivery':
        return row.partialDelivery ?? '-';
      case 'Status':
        return row.status ?? '-';
      case 'Enquiry Status':
        return row.isStarted == true
            ? "Started"
            : row.isclosed == true
                ? "Closed"
                : 'Not Started';

      default:
        return '-';
    }
  }
}
