class GetSellerProfileParams {
  final String token;
  final String loginID;
  final String deviceID;

  GetSellerProfileParams(
      {required this.token, required this.loginID, required this.deviceID});

  Map<String, dynamic> toJson() =>
      {"Token": token, "LoginID": loginID, "DeviceID": deviceID};
}
