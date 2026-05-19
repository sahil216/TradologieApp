import 'package:equatable/equatable.dart';

class AdminLoginSuccess extends Equatable {
  final int? loginId;
  final String? apiVerificationCode;

  const AdminLoginSuccess({
    this.loginId,
    this.apiVerificationCode,
  });

  @override
  List<Object?> get props => [loginId, apiVerificationCode];
}
