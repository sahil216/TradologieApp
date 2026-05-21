import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/phone_number_utils.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/mobile_number_edit_dialog.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/update_agro_fmcg_mobile_detail_usecase.dart';
import 'package:tradologie_app/injection_container.dart' as di;

/// API `Type` values for [DashboardMobileFlow.syncMobileToServer].
abstract final class DashboardMobileType {
  static const String agroSeller = 'agroseller';
  static const String agroBuyer = 'agrobuyer';
  static const String fmcgSeller = 'fmcgseller';
  static const String fmcgBuyer = 'fmcgbuyer';
}

class StoredPhone {
  final String countryCode;
  final String mobileNumber;

  const StoredPhone({
    required this.countryCode,
    required this.mobileNumber,
  });
}

/// Shared dashboard flow: Google phone hint (Android) → mobile number dialog.
class DashboardMobileFlow {
  DashboardMobileFlow._();

  static Future<StoredPhone> loadFromStorage(
    SecureStorageService storage,
  ) async {
    final storedMobile = await storage.read(AppStrings.mobileNo);
    final storedCountryCode = await storage.read(AppStrings.countryCode);

    var mobileNumber = storedMobile ?? '';
    var countryCode = storedCountryCode ?? '';

    if (countryCode.isEmpty && mobileNumber.isNotEmpty) {
      final parsed = parseHintPhoneNumber(mobileNumber);
      countryCode = parsed.countryCode;
      mobileNumber = parsed.mobileNumber;
    }

    return StoredPhone(countryCode: countryCode, mobileNumber: mobileNumber);
  }

  static Future<void> persist(
    SecureStorageService storage,
    StoredPhone phone,
  ) async {
    await storage.write(AppStrings.countryCode, phone.countryCode);
    await storage.write(AppStrings.mobileNo, phone.mobileNumber);
  }

  static Future<String?> resolveUserId(
    SecureStorageService storage,
    String type,
  ) async {
    switch (type) {
      case DashboardMobileType.agroSeller:
        return await storage.read(AppStrings.vendorId);
      case DashboardMobileType.agroBuyer:
        return await storage.read(AppStrings.customerId);
      case DashboardMobileType.fmcgSeller:
      case DashboardMobileType.fmcgBuyer:
        return await storage.read(AppStrings.loginId);
      default:
        return null;
    }
  }

  /// Posts mobile to server after dialog submit. Returns API message on success.
  static Future<String?> syncMobileToServer({
    required SecureStorageService storage,
    required String type,
    required StoredPhone phone,
  }) async {
    final token = await storage.read(AppStrings.apiVerificationCode) ?? '';
    final id = (await resolveUserId(storage, type))?.trim() ?? '';
    if (token.isEmpty || id.isEmpty) {
      return null;
    }

    final params = UpdateAgroFmcgMobileDetailParams(
      token: token,
      type: type,
      id: id,
      countryCode: phone.countryCode,
      mobile: phone.mobileNumber,
      deviceID: Constants.deviceID,
    );

    final response =
        await di.sl<UpdateAgroFmcgMobileDetailUsecase>()(params);
    return response.fold((_) => null, (message) => message);
  }

  static bool hasValidPhone(StoredPhone phone) => hasValidStoredPhone(
        countryCode: phone.countryCode,
        mobileNumber: phone.mobileNumber,
      );

  /// Builds a stored phone from profile/API fields (e.g. FMCG seller profile).
  static StoredPhone? phoneFromProfile({
    String? mobile,
    String? countryCode,
  }) {
    final rawMobile = mobile?.trim() ?? '';
    if (rawMobile.isEmpty) return null;

    var cc = normalizeCountryCodeForStorage(countryCode ?? '');
    var national = rawMobile.replaceAll(RegExp(r'\D'), '');

    if (cc.isEmpty) {
      final parsed = parseHintPhoneNumber(rawMobile);
      cc = parsed.countryCode;
      national = parsed.mobileNumber;
    } else if (national.length > 10 && national.startsWith(cc)) {
      national = national.substring(cc.length);
    }

    final phone = StoredPhone(countryCode: cc, mobileNumber: national);
    return hasValidPhone(phone) ? phone : null;
  }

  /// Returns saved phone when user submits; null if skipped or dismissed.
  static Future<StoredPhone?> collectMobileIfNeeded({
    required BuildContext context,
    required String countryCode,
    required String mobileNumber,
    bool barrierDismissible = false,
  }) async {
    if (hasValidStoredPhone(
      countryCode: countryCode,
      mobileNumber: mobileNumber,
    )) {
      return null;
    }

    var country = countryCode;
    var mobile = mobileNumber;

    // Google Phone Hint is Android-only; iOS goes straight to the dialog.
    if (Platform.isAndroid) {
      try {
        final parsed = await requestGooglePhoneHint();
        if (parsed != null) {
          country = parsed.countryCode;
          mobile = parsed.mobileNumber;
        }
      } catch (_) {
        if (context.mounted) {
          CommonToast.error('Could not open phone number picker');
        }
      }
    }

    if (!context.mounted) return null;

    final result = await showMobileNumberEditDialog(
      context: context,
      initialCountryCode: country,
      initialMobileNumber: mobile,
      barrierDismissible: barrierDismissible,
    );

    if (result == null) return null;

    return StoredPhone(
      countryCode: result.countryCode,
      mobileNumber: result.mobileNumber,
    );
  }
}
