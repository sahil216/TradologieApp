import 'package:equatable/equatable.dart';

import 'send_otp_result.dart';

class SendOtp extends Equatable {
  final SendOtpResult? result;
  final int? id;
  final dynamic exception;
  final int? status;
  final bool? isCanceled;
  final bool? isCompleted;
  final int? creationOptions;
  final dynamic asyncState;
  final bool? isFaulted;

  const SendOtp({
    this.result,
    this.id,
    this.exception,
    this.status,
    this.isCanceled,
    this.isCompleted,
    this.creationOptions,
    this.asyncState,
    this.isFaulted,
  });
  @override
  List<Object?> get props => [
        result,
        id,
        exception,
        status,
        isCanceled,
        isCompleted,
        creationOptions,
        asyncState,
        isFaulted,
      ];
}
