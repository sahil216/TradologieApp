import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class CommonDropdown<T> extends StatelessWidget {
  final String label;
  final Key? dropdownKey;
  final String hint;
  final T? selectedItem;
  final List<T>? items;
  final FutureOr<List<T>> Function(String filter, LoadProps? loadProps)?
      asyncItems;
  final String Function(T) itemAsString;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool Function(T item, T selectedItem)? compareFn;

  const CommonDropdown({
    super.key,
    required this.label,
    this.dropdownKey,
    required this.hint,
    required this.itemAsString,
    required this.onChanged,
    this.selectedItem,
    this.items,
    this.asyncItems,
    this.validator,
    this.compareFn,
  }) : assert(items != null || asyncItems != null,
            'Either items or asyncItems must be provided');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          label,
          style: TextStyleConstants.semiBold(context, fontSize: 16),
        ),
        const SizedBox(height: 6),
        DropdownSearch<T>(
          selectedItem: selectedItem,
          key: dropdownKey,
          items: asyncItems,
          itemAsString: itemAsString,
          onChanged: onChanged,
          validator: validator,
          compareFn: compareFn,
          dropdownBuilder: (context, selectedItem) {
            if (selectedItem == null) {
              return Text(
                hint,
                style: TextStyleConstants.regular(context, fontSize: 14)
                    .copyWith(color: AppColors.black),
              );
            }

            return Text(
              itemAsString(selectedItem),
              style: TextStyleConstants.regular(context, fontSize: 15)
                  .copyWith(color: AppColors.black), // change style here
            );
          },
          popupProps: PopupProps.modalBottomSheet(
            showSearchBox: true, // search is visible
            fit: FlexFit.loose,
            containerBuilder: (context, popupWidget) {
              return SafeArea(
                top: false,
                child: popupWidget,
              );
            },

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search.',
                prefixIcon: const Icon(Icons.search),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.grayText),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.blue),
                ),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

              // 👇 DEFAULT BORDER
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grayText,
                  width: 1.2,
                ),
              ),

              // 👇 ENABLED (normal state)
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.grayText,
                  width: 1.2,
                ),
              ),

              // 👇 WHEN USER TAPS FIELD
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.blue,
                  width: 1.6,
                ),
              ),

              // 👇 VALIDATION ERROR
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.red,
                  width: 1.4,
                ),
              ),

              // 👇 ERROR + FOCUSED
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.red,
                  width: 1.6,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
