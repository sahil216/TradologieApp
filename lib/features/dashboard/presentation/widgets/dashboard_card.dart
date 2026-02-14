import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/responsive.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';

import '../../../../core/widgets/custom_text/text_style_constants.dart';
import '../../domain/entities/dashboard_result.dart';

class DashboardCard extends StatelessWidget {
  final DashboardResult item;
  final VoidCallback onParticipateNowPressed;

  const DashboardCard(
      {super.key, required this.item, required this.onParticipateNowPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: (.05)),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CommonSingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: Uri.encodeFull(EndPoints.getImage(
                item.groupName?.replaceAll(" ", "-") ?? "",
              )),
              height: 160,
              placeholder: (context, url) => CommonLoader(),
              errorWidget: (context, url, error) {
                debugPrint("Image load failed: $error");
                return const Icon(Icons.broken_image);
              },
              httpHeaders: const {
                "Connection": "keep-alive",
              },
            ),
            const SizedBox(height: 12),
            Text(
              item.groupName ?? "",
              style: TextStyleConstants.medium(
                context,
                fontSize: 28,
                color: AppColors.defaultText,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                item.auctionName ?? '',
                style: TextStyleConstants.regular(
                  context,
                  fontSize: 16,
                  color: AppColors.defaultText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _infoRow(context, 'Code', item.auctionCode ?? ''),
            _infoRow(context, 'Currency', item.currencyName ?? ''),
            _infoRow(context, 'Port Of Discharge', item.portOfDischarge ?? ''),
            _infoRow(context, 'Delivery', item.partialDelivery ?? ''),
            _infoRow(context, 'Delivery State', item.deliveryState ?? ''),
            _infoRow(context, 'Delivery Date', item.deliveryLastDate ?? ''),
            _infoRow(context, 'Payment Term', item.paymentTerm ?? ''),
            // const Spacer(),
            SizedBox(height: 16),
            CommonButton(
              onPressed: onParticipateNowPressed,
              text: 'Participate Now',
              width: double.infinity,
            ),
            // const Spacer(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Widget _imageShimmer() {
  //   return Container(
  //     color: AppColors.grayText.withValues(alpha:0.2),
  //     child: const Center(
  //       child: CircularProgressIndicator(strokeWidth: 2),
  //     ),
  //   );
  // }

  Widget _infoRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyleConstants.semiBold(context,
                  fontSize: 16, color: AppColors.defaultText)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyleConstants.regular(context,
                  fontSize: 16, color: AppColors.defaultText),
            ),
          ),
        ],
      ),
    );
  }
}
