import 'package:flutter/material.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/custom_text/common_text_widget.dart';

class SupplierInfoCard extends StatelessWidget {
  final SupplierList supplier;
  final VoidCallback addRemoveShortListButton;
  final bool isShortlisted;
  const SupplierInfoCard(
      {super.key,
      required this.supplier,
      required this.addRemoveShortListButton,
      required this.isShortlisted});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Main Card
        Container(
          margin: EdgeInsets.only(left: 28),
          padding: EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // <-- important
            children: [
              /// Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _logo(),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          supplier.companyName ?? "",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        CommonText(
                          supplier.vendorDescription ?? "",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              /// Info Grid
              Row(
                children: [
                  Expanded(
                      child: infoItem(context, "Annual TurnOver",
                          supplier.annualTurnOver ?? "")),
                  SizedBox(width: 12),
                  Expanded(
                      child: infoItem(context, "Year Of Establishment",
                          supplier.yearOfEstablishment ?? "")),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: infoItem(context, "Certifications",
                          supplier.certifications ?? "")),
                  SizedBox(width: 12),
                  Expanded(
                      child: infoItem(context, "Area Of Operation",
                          supplier.areaOfOperation ?? "")),
                ],
              ),

              SizedBox(height: 20),

              /// Actions
              Row(
                children: [
                  supplier.webUrl == null || supplier.webUrl == ""
                      ? SizedBox()
                      : InkWell(
                          onTap: () {
                            if (supplier.webUrl != null) {
                              launchUrl(Uri.parse(supplier.webUrl ?? ""));
                            }
                          },
                          child: CommonText(
                            "View Microsite",
                            style: TextStyleConstants.medium(context,
                                color: Color(0xff0b3c6d),
                                fontSize: 14,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CommonButton(
                      onPressed: addRemoveShortListButton,
                      text: isShortlisted
                          ? "Remove from shortlist"
                          : "Add to shortlist",
                      backgroundColor:
                          isShortlisted ? AppColors.blue200 : AppColors.blue100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        /// Patron Strip
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 32,
            decoration: BoxDecoration(
              color: Color(0xff4a9cf0),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Center(
                child: CommonText(
                  "Patron",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _logo() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        image: DecorationImage(
          image: NetworkImage(
            "${supplier.vendorLogo}",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  Widget infoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          label,
          style: TextStyleConstants.semiBold(
            context,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        CommonText(
          value,
          style: TextStyleConstants.medium(
            context,
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
