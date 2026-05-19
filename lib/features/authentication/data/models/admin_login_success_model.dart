import '../../domain/entities/admin_login_success.dart';

class AdminLoginSuccessModel extends AdminLoginSuccess {
  const AdminLoginSuccessModel({
    super.loginId,
    super.apiVerificationCode,
  });

  factory AdminLoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      AdminLoginSuccessModel(
        loginId: json['LoginID'] is int
            ? json['LoginID'] as int
            : int.tryParse(json['LoginID']?.toString() ?? ''),
        apiVerificationCode: json['ApiVerificationCode']?.toString(),
      );
}
