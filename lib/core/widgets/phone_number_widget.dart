import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryPhoneField extends StatefulWidget {
  final Country initialCountry;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<Country>? onCountryChanged;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;
  final bool enabled;
  final bool readOnly;
  final int? maxLength;

  /// Validator function like TextFormField
  final String? Function(String?)? validator;

  const CountryPhoneField({
    super.key,
    required this.initialCountry,
    this.hintText,
    this.onChanged,
    this.onCountryChanged,
    this.controller,
    this.focusNode,
    required this.autovalidateMode,
    this.enabled = true,
    this.readOnly = false,
    this.maxLength,
    this.validator,
  });

  @override
  State<CountryPhoneField> createState() => _CountryPhoneFieldState();
}

class _CountryPhoneFieldState extends State<CountryPhoneField> {
  late Country _country;
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _country = widget.initialCountry;
    _controller = widget.controller ?? TextEditingController();

    // Listen to changes and validate dynamically
    _controller.addListener(_validate);
  }

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
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: isTablet ? 64 : 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _errorText != null ? Colors.red : Colors.grey.shade400,
            ),
          ),
          child: Row(
            children: [
              /// Country Picker
              InkWell(
                onTap: widget.enabled
                    ? () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            bottomSheetHeight:
                                MediaQuery.of(context).size.height * 0.8,
                          ),
                          onSelect: (country) {
                            setState(() => _country = country);
                            widget.onCountryChanged?.call(country);
                          },
                        );
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        _country.flagEmoji,
                        style: TextStyle(
                          fontSize: isTablet ? 26 : 22,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "+${_country.phoneCode}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Divider
              Container(
                width: 1,
                height: 30,
                color: Colors.grey.shade400,
              ),

              /// Phone Input
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  focusNode: widget.focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  autovalidateMode: widget.autovalidateMode,
                  maxLength: widget.maxLength,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    _validate();
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: isTablet ? 18 : 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Error Text
        if (_errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
