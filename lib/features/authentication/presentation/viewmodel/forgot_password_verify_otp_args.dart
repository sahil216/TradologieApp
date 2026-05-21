class ForgotPasswordVerifyOtpArgs {
  final String userId;
  final int? vendorId;

  const ForgotPasswordVerifyOtpArgs({
    required this.userId,
    this.vendorId,
  });
}
