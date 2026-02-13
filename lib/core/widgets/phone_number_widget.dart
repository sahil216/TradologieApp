import 'package:flutter/material.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';

class CountryPhoneField extends StatefulWidget {
  final CountryCodeList initialCountry;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<CountryCodeList>? onCountryChanged;
  final List<CountryCodeList> countryList;

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
    required this.countryList,
  });

  @override
  State<CountryPhoneField> createState() => _CountryPhoneFieldState();
}

class _CountryPhoneFieldState extends State<CountryPhoneField> {
  late CountryCodeList _country;
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
                        _openCountryPicker(context);
                        // showCountryPicker(
                        //   context: context,
                        //   showPhoneCode: true,
                        //   countryListTheme: CountryListThemeData(
                        //     bottomSheetHeight:
                        //         MediaQuery.of(context).size.height * 0.8,
                        //   ),
                        //   onSelect: (country) {
                        //     setState(() => _country = country);
                        //     widget.onCountryChanged?.call(country);
                        //   },
                        // );
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      Text(
                        "+${_country.countryCode}",
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

  void _openCountryPicker(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: height, // ✅ 70% height
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                /// drag handle (optional but nice UX)
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),

                /// ✅ List
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.countryList.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final country = widget.countryList[index];

                      return ListTile(
                        title: Text(country.countryName ?? ""),
                        trailing: Text("+${country.countryCode}"),
                        onTap: () {
                          Navigator.pop(context);

                          setState(() {
                            _country = country;
                          });

                          widget.onCountryChanged?.call(country);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
