import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_colors.dart';
import 'custom_text/custom_required_text_rich.dart';
import 'custom_text/text_style_constants.dart';

class CommonTextField extends StatefulWidget {
  final int? maxLines;
  final int? maxLength;

  final double height;
  final double borderRadius;

  final String? hintText;
  final String? titleText;
  final String? labalText;
  final String? textRequired;

  final bool isEnable;
  final bool readOnly;
  final bool autofocus;
  final bool? isRequired;
  final bool isObsecureText;

  final Color? textColor;
  final Color? hintColor;
  final Color? titleColor;
  final Color? labalColor;
  final Color? borderColor;
  final Color? backgroundColor;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? titleWidget;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  final TextStyle? titleStyle;
  final TextStyle? labalStyle;

  final TextAlign textAlign;
  final FocusNode? focusNode;
  final List<BoxShadow>? boxShadow;
  final TextInputType textInputType;
  final TextDirection? textDirection;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final CrossAxisAlignment? crossAxisAlignment;

  final EdgeInsetsGeometry? contentPadding;

  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;

  final bool Function(String)? condition;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  final List<TextInputFormatter>? inputFormatters;

  const CommonTextField({
    super.key,
    this.maxLines = 1,
    this.maxLength,
    //
    this.height = 55,
    this.borderRadius = 10,
    //
    this.hintText,
    this.titleText,
    this.labalText,
    this.textRequired,
    //
    this.isEnable = true,
    this.readOnly = false,
    this.autofocus = false,
    this.isRequired,
    this.isObsecureText = false,
    //
    this.textColor,
    this.hintColor,
    this.titleColor,
    this.labalColor,
    this.borderColor,
    this.backgroundColor,

    //
    this.suffixIcon,
    this.prefixIcon,
    this.titleWidget,
    //
    this.titleStyle,
    this.labalStyle,
    //
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.boxShadow,
    this.textInputType = TextInputType.text,
    this.textDirection,
    required this.controller,
    this.textInputAction,
    this.crossAxisAlignment,
    //
    this.contentPadding,
    //
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    //
    this.condition,
    this.onChanged,
    this.onSubmitted,
    //
    this.inputFormatters,
    this.validator,
    required this.autovalidateMode,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  String? _errorText;

  void _validate() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      if (error != _errorText) {
        setState(() {
          _errorText = error;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    // Listen to changes and validate dynamically
    _controller.addListener(_validate);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  late TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          widget.crossAxisAlignment ?? CrossAxisAlignment.stretch,
      children: [
        widget.titleWidget != null
            ? widget.titleWidget!
            : widget.titleText != null
                ? Container(
                    margin: EdgeInsetsDirectional.only(start: 10, bottom: 3),
                    child: CustomRequiredTextRich(
                      text: widget.titleText!,
                      showRequired: widget.isRequired ?? false,
                      style: widget.titleStyle ??
                          TextStyleConstants.medium(
                            context,
                            color: widget.titleColor ?? AppColors.blackApp,
                            fontSize: 15,
                          ),
                    ),
                  )
                : const SizedBox.shrink(),
        Container(
          constraints: BoxConstraints(
            minHeight: widget.height,
          ),
          decoration: BoxDecoration(
            boxShadow: widget.boxShadow,
            color: widget.backgroundColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ), //
          child: TextFormField(
            focusNode: widget.focusNode,
            keyboardType: widget.textInputType,
            controller: _controller,
            enableSuggestions: false,
            autocorrect: false,
            autofocus: widget.autofocus,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            enabled: widget.isEnable,
            readOnly: widget.readOnly,
            obscureText: widget.isObsecureText,
            obscuringCharacter: '\u25cf',
            onChanged: widget.onChanged,
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            cursorColor: AppColors.defaultText,
            textAlign: widget.textAlign,
            cursorHeight: 25,
            style: TextStyleConstants.medium(
              context,
              height: 2.2,
              fontSize: 16,
              color: widget.textColor ?? AppColors.blackApp,
            ),
            decoration: InputDecoration(
              contentPadding: widget.contentPadding ??
                  EdgeInsets.only(
                    left: 10,
                    right: 22,
                  ),
              // constraints: BoxConstraints(
              //   minHeight: (widget.maxLines != null && widget.maxLines! > 1)
              //       ? 0
              //       : widget.height,
              //   maxHeight: (widget.maxLines != null && widget.maxLines! > 1)
              //       ? double.infinity
              //       : widget.height,
              //   maxWidth: double.infinity,
              //   minWidth: double.infinity,
              // ),
              labelText: widget.labalText,
              labelStyle: widget.labalStyle ??
                  TextStyleConstants.medium(
                    context,
                    height: 2.2,
                    fontSize: 19,
                    color: widget.labalColor ?? AppColors.blackApp,
                  ),
              hintText: widget.hintText,
              hintStyle: TextStyleConstants.medium(context,
                  color: widget.hintColor ?? AppColors.grayText, fontSize: 14),
              suffixIconConstraints: widget.suffixIconConstraints,
              suffixIcon: widget.suffixIcon,
              prefixIconConstraints: widget.prefixIconConstraints,
              prefixIcon: widget.prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.border,
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.border,
                  width: 1.2,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ),

        // /// Error Text
        // if (_errorText != null) ...[
        //   const SizedBox(height: 6),
        //   Text(
        //     _errorText!,
        //     style: const TextStyle(
        //       color: Colors.red,
        //       fontSize: 12,
        //     ),
        //   ),
        // ],
      ],
    );
  }
}
