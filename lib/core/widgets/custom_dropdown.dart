// import 'package:flutter/material.dart';
//
// import 'package:flutter_svg/svg.dart';
// import 'custom_text/text_style_constants.dart';

// import '../../../core/utils/extensions.dart';
// import '../utils/app_colors.dart';
// import '../utils/assets_manager.dart';
// import 'custom_text/custom_required_text_rich.dart';

// class CustomDropdown extends StatelessWidget {
//   final double height;
//   final double radius;
//   final double borderWidth;
//   final double itemFontSize;
//   final double hintFontSize;
//   final double titleFontSize;

//   final String? hint;
//   final String? title;
//   final String? textRequired;

//   final bool? isRequired;

//   final Color? itemColor;
//   final Color? iconColor;
//   final Color? hintColor;
//   final Color? titleColor;
//   final Color? borderColor;
//   final Color? backgroundColor;

//   final Widget? hintWidget;
//   final Widget? iconWidget;
//   final ValueNotifier valueSelected;

//   final EdgeInsetsGeometry? hintPadding;
//   final EdgeInsetsGeometry? itemPadding;
//   final EdgeInsetsGeometry? titlePadding;

//   final void Function(dynamic)? onChanged;
//   final bool Function(dynamic)? condition;

//   final List<dynamic> listSelectModel;

//   const CustomDropdown({
//     super.key,
//     this.height = 55,
//     this.radius = 30,
//     this.borderWidth = 1,
//     this.itemFontSize = 14,
//     this.hintFontSize = 16,
//     this.titleFontSize = 15,
//     //
//     this.hint,
//     this.title,
//     this.textRequired,
//     //
//     this.isRequired = false,
//     //
//     this.itemColor,
//     this.iconColor,
//     this.hintColor,
//     this.titleColor,
//     this.borderColor,
//     this.backgroundColor,
//     //
//     this.hintWidget,
//     this.iconWidget,
//     required this.valueSelected,
//     //
//     this.hintPadding,
//     this.itemPadding,
//     this.titlePadding,
//     //
//     this.onChanged,
//     this.condition,
//     //
//     required this.listSelectModel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         title != null
//             ? Container(
//                 margin: EdgeInsetsDirectional.only(start: 16, bottom: 3),
//                 padding: titlePadding,
//                 child: CustomRequiredTextRich(
//                   text: title!,
//                   showRequired: isRequired ?? false,
//                   style: TextStyleConstants.medium(
//                     context,
//                     color: titleColor ?? AppColors.black,
//                     fontSize: titleFontSize,
//                   ),
//                 ),
//               )
//             : const SizedBox.shrink(),
//         ValueListenableBuilder(
//           valueListenable: valueSelected,
//           builder: (context, value, _) {
//             return DropdownButtonHideUnderline(
//               child: DropdownButton2<dynamic>(
//                 isExpanded: true,
//                 hint: hintWidget ??
//                     Padding(
//                       padding: hintPadding ??
//                           EdgeInsetsDirectional.only(start: 22),
//                       child: Row(
//                         children: [
//                           if (iconWidget != null) iconWidget!,
//                           Text(
//                             hint ?? "",
//                             maxLines: 1,
//                             style: TextStyleConstants.medium(
//                               context,
//                               color: hintColor ?? AppColors.grayTextHint,
//                               fontSize: hintFontSize,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 selectedItemBuilder: (context) {
//                   return listSelectModel.map(
//                     (val) {
//                       return Padding(
//                         padding: hintPadding ??
//                             EdgeInsetsDirectional.only(start: 22),
//                         child: Row(
//                           children: [
//                             if (iconWidget != null) iconWidget!,
//                             Text(
//                               val.name,
//                               maxLines: 1,
//                               style: TextStyleConstants.medium(
//                                 context,
//                                 height: 2.2,
//                                 fontSize: 19,
//                                 color: hintColor ?? AppColors.defaultText,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ).toList();
//                 },
//                 items: listSelectModel.map(
//                   (val) {
//                     return DropdownMenuItem<dynamic>(
//                       value: val,
//                       child: Container(
//                         width: context.width,
//                         padding: itemPadding ??
//                             EdgeInsetsDirectional.only(start: 22),
//                         child: Text(
//                           val.name,
//                           style: TextStyleConstants.medium(
//                             context,
//                             height: 2.2,
//                             fontSize: 19,
//                             color: hintColor ?? AppColors.defaultText,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ).toList(),
//                 value: value,
//                 onChanged: (value) {
//                   valueSelected.value = value;
//                   if (onChanged != null) {
//                     onChanged!(value);
//                   }
//                 },
//                 buttonStyleData: ButtonStyleData(
//                   height: height,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: AppColors.defaultBackgroundDropdown,
//                     border: Border.all(
//                       color: borderColor ?? AppColors.borderDark,
//                       width: borderWidth,
//                     ),
//                     borderRadius: BorderRadius.circular(radius),
//                   ),
//                 ),
//                 iconStyleData: IconStyleData(
//                   icon: Container(
//                     margin: EdgeInsetsDirectional.only(end: 22),
//                     child: SvgPicture.asset(
//                       VectorAssets.iosArrowDown,
//                       colorFilter: ColorFilter.mode(
//                         iconColor ?? AppColors.grayTextHint,
//                         BlendMode.srcIn,
//                       ),
//                       width: 13.55,
//                     ),
//                   ),
//                 ),
//                 dropdownStyleData: DropdownStyleData(
//                   elevation: 4,
//                   offset: Offset(0, -6),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     border: Border.all(
//                       color: borderColor ?? Colors.transparent,
//                       width: borderWidth,
//                     ),
//                     borderRadius: BorderRadius.circular((radius - 15)),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         if (condition != null && textRequired != null)
//           ValueListenableBuilder(
//             valueListenable: valueSelected,
//             builder: (context, value, _) {
//               if (condition!(value)) {
//                 return Padding(
//                   padding: EdgeInsetsDirectional.only(start: 16, top: 3),
//                   child: Text(
//                     textRequired!,
//                     style: TextStyleConstants.light(
//                       context,
//                       fontSize: 9,
//                       color: AppColors.red,
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//       ],
//     );
//   }
// }
