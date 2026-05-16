import 'dart:io';

import 'package:flutter/services.dart';
import 'package:phone_hint_android/phone_hint_android.dart';

/// Parsed phone from Google Phone Hint (typically E.164, e.g. +919876543210).
class ParsedPhoneNumber {  final String countryCode;
  final String mobileNumber;

  const ParsedPhoneNumber({
    required this.countryCode,
    required this.mobileNumber,
  });

  bool get isEmpty => countryCode.isEmpty && mobileNumber.isEmpty;

  String get displayWithPlus => '+$countryCode $mobileNumber';
}

/// Splits a hint/full number into [countryCode] (no +) and national [mobileNumber].
ParsedPhoneNumber parseHintPhoneNumber(String input) {
  var digits = input.replaceAll(RegExp(r'[^\d+]'), '').trim();
  if (digits.startsWith('+')) {
    digits = digits.substring(1);
  }
  digits = digits.replaceAll(RegExp(r'\D'), '');

  if (digits.isEmpty) {
    return const ParsedPhoneNumber(countryCode: '', mobileNumber: '');
  }

  // India: +91 + 10-digit mobile
  if (digits.length == 12 && digits.startsWith('91')) {
    return ParsedPhoneNumber(
      countryCode: '91',
      mobileNumber: digits.substring(2),
    );
  }

  // Local India: 0 + 10 digits
  if (digits.length == 11 && digits.startsWith('0')) {
    return ParsedPhoneNumber(
      countryCode: '91',
      mobileNumber: digits.substring(1),
    );
  }

  // 10-digit national (default India for this app)
  if (digits.length == 10) {
    return ParsedPhoneNumber(countryCode: '91', mobileNumber: digits);
  }

  // North America: 1 + 10 digits
  if (digits.length == 11 && digits.startsWith('1')) {
    return ParsedPhoneNumber(
      countryCode: '1',
      mobileNumber: digits.substring(1),
    );
  }

  // Generic: last 10 digits = mobile, prefix = country code
  if (digits.length > 10) {
    return ParsedPhoneNumber(
      countryCode: digits.substring(0, digits.length - 10),
      mobileNumber: digits.substring(digits.length - 10),
    );
  }

  return ParsedPhoneNumber(countryCode: '91', mobileNumber: digits);
}

/// Reads mobile from API maps that use `MobileNo` or `mobileNo`.
String readApiMobileField(
  Map<dynamic, dynamic> data, {
  String? fallback,
}) {
  final raw = data['MobileNo'] ?? data['mobileNo'] ?? data['Mobile'] ?? fallback;
  return raw?.toString().trim() ?? '';
}

/// Normalizes login/API country values for secure storage (digits only).
String normalizeCountryCodeForStorage(String input) {
  var code = input.trim();
  if (code.contains('~')) {
    code = code.split('~').last;
  }
  return code.replaceAll(RegExp(r'[^\d]'), '');
}

/// True when we have a usable national number in storage.
bool hasValidStoredPhone({
  String? countryCode,
  String? mobileNumber,
}) {
  final mobile = (mobileNumber ?? '').trim();
  final country = (countryCode ?? '').trim();

  if (mobile.isEmpty && country.isEmpty) {
    return false;
  }

  const invalidTokens = {'-', 'null', 'none', 'n/a'};
  if (invalidTokens.contains(mobile.toLowerCase())) {
    return false;
  }

  final mobileDigits = mobile.replaceAll(RegExp(r'\D'), '');
  return mobileDigits.length >= 6;
}

/// Opens Google Phone Number Hint on Android. Returns null if cancelled or unavailable.
Future<ParsedPhoneNumber?> requestGooglePhoneHint() async {
  if (!Platform.isAndroid) {
    return null;
  }

  try {
    final phone = await PhoneHintAndroid().getPhoneNumber();
    if (phone == null || phone.trim().isEmpty) {
      return null;
    }
    final parsed = parseHintPhoneNumber(phone.trim());
    return parsed.isEmpty ? null : parsed;
  } on PlatformException catch (e) {
    final message = e.message ?? '';
    if (e.code == 'PHONE_HINT_FAILURE' &&
        message.toLowerCase().contains('dismissed')) {
      return null;
    }
    rethrow;
  }
}