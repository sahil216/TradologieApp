class GetSellerDocumentsParams {
  final String token;
  final String loginID;
  final String deviceID;

  GetSellerDocumentsParams(
      {required this.token, required this.loginID, required this.deviceID});

  Map<String, dynamic> toJson() =>
      {"Token": token, "LoginID": loginID, "DeviceID": deviceID};
}
