import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_no_record_widget.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/custom_error_network_widget.dart';
import 'package:tradologie_app/core/widgets/custom_error_widget.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation_result.dart';
import 'package:tradologie_app/features/negotiation/presentation/cubit/negotiation_cubit.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../domain/entities/negotiation.dart';
import '../../domain/usecases/get_negotiation_usecase.dart';

class NegotiationScreen extends StatefulWidget {
  const NegotiationScreen({
    super.key,
  });

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  Negotiation? negotiation;
  List<NegotiationResult>? negotiationData;

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
    'Start Date',
    // 'End Date',
    // 'Preffered Date',
    // 'Enquiry Status',
    // 'Total Quantity',
    // 'Minimum Quantity',
    // 'Participate Quantity',
    // 'Last Date of Delivery',
  ];

  final Map<String, double> columnWidths = {
    // 'S.No.': 100,
    'Negotiation Code': 200,
    // 'Negotiation Name': 200,
    'Order Status': 150,
    'Start Date': 150,
    // 'End Date': 250,
    // 'Preffered Date': 150,
    // 'Enquiry Status': 150,
    // 'Total Quantity': 200,
    // 'Minimum Quantity': 200,
    // 'Participate Quantity': 200,
    // 'Last Date of Delivery': 250,
  };

  NegotiationCubit get cubit => BlocProvider.of<NegotiationCubit>(context);

  @override
  void initState() {
    super.initState();
    getNegotiationData();

    // Force landscape
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

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
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
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
        vendorID: await secureStorage.read(AppStrings.vendorId) ?? "",
        indexNo: page);

    await cubit.getNegotiationData(params);
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
                    Navigator.pushNamed(context, Routes.notificationScreen);
                  },
                  icon: Icon(Icons.notifications)),
              SizedBox(width: 10),
            ]),
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
                      Navigator.pushNamed(context, Routes.myAccountsScreen);
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
            } else if (state is GetNegotiationIsLoading) {
              return const CommonLoader();
            }

            return SafeArea(
                child: Column(
              children: [
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
                                              GestureDetector(
                                                onTap: () {
                                                  Constants.isAndroid14OrBelow &&
                                                          Platform.isAndroid
                                                      ? Navigator.pushNamed(
                                                          context,
                                                          Routes
                                                              .inAppWebViewRoute,
                                                          arguments: WebviewParams(
                                                              url:
                                                                  "${EndPoints.supplierWebsiteurl}/${row.navigateViewUrl}",
                                                              canPop: true,
                                                              isAppBar: true))
                                                      : Navigator.pushNamed(
                                                          context,
                                                          Routes.webViewRoute,
                                                          arguments: WebviewParams(
                                                              url:
                                                                  "${EndPoints.supplierWebsiteurl}/${row.navigateViewUrl}",
                                                              canPop: true,
                                                              isAppBar: true));
                                                },
                                                child: Text(
                                                  _getCellText(row, header),
                                                  style: TextStyleConstants
                                                      .regular(
                                                    context,
                                                    fontSize: 16,
                                                    color:
                                                        AppColors.defaultText,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return _cell(
                                        _getCellText(row, header),
                                        isShowView: false,
                                        width: columnWidths[header] ??
                                            defaultColumnWidth,
                                        isUnderline: header.toLowerCase() ==
                                            'order status',
                                        color: header.toLowerCase() ==
                                                'order status'
                                            ? AppColors.blue
                                            : null,
                                        onViewTap: () {
                                          if (header.toLowerCase() ==
                                              'negotiation code') {
                                            Constants.isAndroid14OrBelow &&
                                                    Platform.isAndroid
                                                ? Navigator.pushNamed(context,
                                                    Routes.inAppWebViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.supplierWebsiteurl}/${row.navigateViewUrl}",
                                                        canPop: true,
                                                        isAppBar: true))
                                                : Navigator.pushNamed(
                                                    context, Routes.webViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.supplierWebsiteurl}/${row.navigateViewUrl}",
                                                        canPop: true,
                                                        isAppBar: true));
                                          }
                                        },
                                        onTap: () {
                                          if (header.toLowerCase() ==
                                                  'order status' &&
                                              row.linkType == "directlink" &&
                                              row.orderStatus?.toLowerCase() ==
                                                  "update rate") {
                                            Constants.isAndroid14OrBelow &&
                                                    Platform.isAndroid
                                                ? Navigator.pushNamed(context,
                                                    Routes.inAppWebViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.supplierWebsiteurl}/${row.navigateUrl}",
                                                        canPop: true,
                                                        isAppBar: true))
                                                : Navigator.pushNamed(
                                                    context, Routes.webViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.supplierWebsiteurl}/${row.navigateUrl}",
                                                        canPop: true,
                                                        isAppBar: true));
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
                                          _detail("Negotiation Code ",
                                              row.auctionCode ?? '-', true, () {
                                            Constants.isAndroid14OrBelow &&
                                                    Platform.isAndroid
                                                ? Navigator.pushNamed(context,
                                                    Routes.inAppWebViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.supplierWebsiteurl}/${row.navigateViewUrl}",
                                                        canPop: true,
                                                        isAppBar: true))
                                                : Navigator.pushNamed(
                                                    context, Routes.webViewRoute,
                                                    arguments: WebviewParams(
                                                        url:
                                                            "${EndPoints.supplierWebsiteurl}/${row.navigateViewUrl}",
                                                        canPop: true,
                                                        isAppBar: true));
                                          }),
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
                                                Constants.isAndroid14OrBelow &&
                                                        Platform.isAndroid
                                                    ? Navigator.pushNamed(
                                                        context,
                                                        Routes
                                                            .inAppWebViewRoute,
                                                        arguments: WebviewParams(
                                                            url:
                                                                "${EndPoints.supplierWebsiteurl}/${row.navigateUrl}",
                                                            canPop: true,
                                                            isAppBar: true))
                                                    : Navigator.pushNamed(
                                                        context,
                                                        Routes.webViewRoute,
                                                        arguments: WebviewParams(
                                                            url:
                                                                "${EndPoints.supplierWebsiteurl}/${row.navigateUrl}",
                                                            canPop: true,
                                                            isAppBar: true));
                                              }
                                            },
                                          ),
                                          _detail(
                                              "Start Date ",
                                              Constants.dateFormat(
                                                  DateTime.tryParse(
                                                          row.startDate ??
                                                              "") ??
                                                      DateTime.now()),
                                              false,
                                              null),
                                          _detail(
                                              "End Date ",
                                              Constants.dateFormat(
                                                  DateTime.tryParse(
                                                          row.endDate ?? "") ??
                                                      DateTime.now()),
                                              false,
                                              null),
                                          _detail(
                                              "Preffered Date",
                                              Constants.dateFormat(
                                                  DateTime.tryParse(
                                                          row.preferredDate ??
                                                              "") ??
                                                      DateTime.now()),
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
                                          _detail(
                                              "Total Quantity ",
                                              row.totalQuantity ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Minimum Quantity ",
                                              row.minQuantity ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Participate Quantity ",
                                              row.participateQuantity ?? '-',
                                              false,
                                              null),
                                          _detail(
                                              "Last Date of Delivery ",
                                              Constants.dateFormat(
                                                  DateTime.tryParse(
                                                          row.deliveryLastDate ??
                                                              "") ??
                                                      DateTime.now()),
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
            ));
          },
        ),
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
                  onPressed: (currentPage < (negotiation?.totalPages ?? 0))
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
      String title, String value, bool isShowView, VoidCallback? onViewTap,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyleConstants.semiBold(context, fontSize: 14)),
          GestureDetector(
            onTap: onTap,
            child: Text(
              value,
              style: TextStyleConstants.regular(context,
                  fontSize: 14,
                  decoration: onTap == null ? null : TextDecoration.underline),
            ),
          ),
          isShowView == true
              ? GestureDetector(
                  onTap: onViewTap,
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
  Widget _cell(String text,
      {double width = 150,
      bool isHeader = false,
      bool isUnderline = false,
      Color? color,
      VoidCallback? onTap,
      VoidCallback? onViewTap,
      bool isShowView = false}) {
    return Container(
      width: width,
      height: isHeader ? 50 : 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade300 : Colors.transparent,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: isHeader
                  ? TextStyleConstants.semiBold(context, fontSize: 16)
                  : TextStyleConstants.regular(context,
                      fontSize: 16,
                      color: color ?? AppColors.defaultText,
                      decoration:
                          isUnderline ? TextDecoration.underline : null),
            ),
          ),
          isShowView
              ? GestureDetector(
                  onTap: onTap,
                  child: IconButton(
                      onPressed: onViewTap,
                      icon: Icon(
                        Icons.remove_red_eye,
                      )),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  /// Map row data to column text
  String _getCellText(NegotiationResult row, String header) {
    switch (header) {
      case 'S.No.':
        return (negotiationData!.indexOf(row) + 1).toString();
      case 'Negotiation Code':
        return row.auctionCode ?? '-';
      case 'Order Status':
        return row.orderStatus ?? '-';
      case 'Start Date':
        return Constants.dateFormat(
            DateTime.tryParse(row.startDate ?? "") ?? DateTime.now());
      case 'End Date':
        return Constants.dateFormat(
            DateTime.tryParse(row.endDate ?? "") ?? DateTime.now());
      case 'Preffered Date':
        return Constants.dateFormat(
            DateTime.tryParse(row.preferredDate ?? "") ?? DateTime.now());
      case 'Enquiry Status':
        return row.isStarted == true
            ? "Started"
            : row.isclosed == true
                ? "Closed"
                : '-';
      case 'Total Quantity':
        return row.totalQuantity ?? '-';
      case 'Minimum Quantity':
        return row.minQuantity ?? '-';
      case 'Participate Quantity':
        return row.participateQuantity ?? '-';
      case 'Last Date of Delivery':
        return Constants.dateFormat(
            DateTime.tryParse(row.deliveryLastDate ?? "") ?? DateTime.now());
      case 'Negotiation Name':
        return row.auctionName ?? '-';
      default:
        return '-';
    }
  }
}
