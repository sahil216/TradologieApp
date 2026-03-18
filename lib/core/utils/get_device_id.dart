import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const _storage = FlutterSecureStorage();
  static const _key = "device_id";

  static Future<String> getDeviceId() async {
    // 1️⃣ Check if already saved
    String? savedId = await _storage.read(key: _key);
    if (savedId != null && savedId.isNotEmpty) {
      return savedId;
    }

    final deviceInfo = DeviceInfoPlugin();
    String deviceId;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        // ⚠️ ANDROID ID (best available)
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        // ⚠️ identifierForVendor (can change on reinstall)
        deviceId = iosInfo.identifierForVendor ?? "";
      } else {
        deviceId = "";
      }
    } catch (e) {
      deviceId = "";
    }

    // 2️⃣ Fallback if empty
    if (deviceId.isEmpty) {
      deviceId = const Uuid().v4();
    }

    // 3️⃣ Persist
    await _storage.write(key: _key, value: deviceId);

    return deviceId;
  }
}
