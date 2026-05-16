import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/common_drop_down.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/get_country_code_list_usecase.dart';
import 'package:tradologie_app/injection_container.dart';

class MobileNumberEditResult {
  final String countryCode;
  final String mobileNumber;

  const MobileNumberEditResult({
    required this.countryCode,
    required this.mobileNumber,
  });
}

/// Shows country code + mobile fields. Returns result on submit, null on dismiss.
Future<MobileNumberEditResult?> showMobileNumberEditDialog({
  required BuildContext context,
  required String initialCountryCode,
  required String initialMobileNumber,
  bool barrierDismissible = true,
}) {
  return showDialog<MobileNumberEditResult>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) => _MobileNumberEditDialog(
      initialCountryCode: initialCountryCode,
      initialMobileNumber: initialMobileNumber,
      barrierDismissible: barrierDismissible,
    ),
  );
}

class _MobileNumberEditDialog extends StatefulWidget {
  const _MobileNumberEditDialog({
    required this.initialCountryCode,
    required this.initialMobileNumber,
    required this.barrierDismissible,
  });

  final String initialCountryCode;
  final String initialMobileNumber;
  final bool barrierDismissible;

  @override
  State<_MobileNumberEditDialog> createState() =>
      _MobileNumberEditDialogState();
}

class _MobileNumberEditDialogState extends State<_MobileNumberEditDialog> {
  late final TextEditingController _mobileController;

  List<CountryCodeList> _countryList = [];
  CountryCodeList? _selectedCountry;
  bool _isLoadingCountries = true;

  @override
  void initState() {
    super.initState();
    _mobileController =
        TextEditingController(text: widget.initialMobileNumber);
    _loadCountries();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final response = await sl<GetCountryCodeListUsecase>()(NoParams());
    if (!mounted) return;

    response.fold(
      (_) => _applyCountryList(const [
        CountryCodeList(countryName: 'India', countryCode: '91'),
      ]),
      _applyCountryList,
    );
  }

  void _applyCountryList(List<CountryCodeList> list) {
    setState(() {
      _countryList = list;
      _selectedCountry = _resolveInitialCountry(list);
      _isLoadingCountries = false;
    });
  }

  CountryCodeList? _resolveInitialCountry(List<CountryCodeList> list) {
    if (list.isEmpty) return null;

    final initial =
        widget.initialCountryCode.trim().replaceAll(RegExp(r'^\+'), '');
    if (initial.isNotEmpty) {
      for (final country in list) {
        final code =
            country.countryCode?.trim().replaceAll(RegExp(r'^\+'), '') ?? '';
        if (code == initial) return country;
      }
    }

    for (final country in list) {
      if (country.countryCode == '91') return country;
    }
    return list.first;
  }

  List<CountryCodeList> _filterCountries(String filter) {
    if (filter.isEmpty) return _countryList;
    final query = filter.toLowerCase();
    return _countryList
        .where(
          (country) =>
              (country.countryName ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  String _countryLabel(CountryCodeList country) {
    final name = country.countryName ?? '';
    final code = country.countryCode ?? '';
    if (name.isEmpty) return '+$code';
    return '$name (+$code)';
  }

  void _submit() {
    final countryCode =
        _selectedCountry?.countryCode?.trim().replaceAll(RegExp(r'^\+'), '');
    final mobileNumber = _mobileController.text.trim();
    if (countryCode == null ||
        countryCode.isEmpty ||
        mobileNumber.isEmpty) {
      return;
    }
    Navigator.of(context).pop(
      MobileNumberEditResult(
        countryCode: countryCode,
        mobileNumber: mobileNumber,
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: AppColors.blueExtraLight.withValues(alpha: 0.35),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.blueLight.withValues(alpha: 0.8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.barrierDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 36),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 380,
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.blueExtraLight,
                                AppColors.blueLight,
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.phone_android_rounded,
                                size: 40,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Verify mobile number',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 19,
                                  letterSpacing: -0.2,
                                  color: AppColors.blueDark,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Confirm your country and mobile number',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  color: AppColors.grayText,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: AppColors.white,
                            elevation: 1,
                            shadowColor: Colors.black.withValues(alpha: 0.08),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Navigator.of(context).pop(),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: AppColors.grayText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_isLoadingCountries)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else ...[
                            CommonDropdown<CountryCodeList>(
                              label: 'Country',
                              hint: 'Select country',
                              selectedItem: _selectedCountry,
                              asyncItems: (filter, loadProps) =>
                                  _filterCountries(filter),
                              itemAsString: _countryLabel,
                              compareFn: (a, b) =>
                                  a.countryId == b.countryId &&
                                  a.countryCode == b.countryCode,
                              onChanged: (country) {
                                setState(() => _selectedCountry = country);
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Mobile number',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grayText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: _fieldDecoration(
                                hintText: 'Enter mobile number',
                              ),
                              onSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: 22),
                            CommonButton(
                              text: 'Submit',
                              width: double.infinity,
                              backgroundColor: AppColors.primary,
                              onPressed: _submit,
                              textStyle: TextStyleConstants.medium(
                                context,
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
