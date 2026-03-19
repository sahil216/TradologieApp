import 'package:tradologie_app/core/utils/constants.dart';

class UpdateSellerDocumentsParams {
  final String token;
  final String loginID;
  final String document;
  final String documentTypeId;
  final String description;

  UpdateSellerDocumentsParams({
    required this.token,
    required this.loginID,
    required this.document,
    required this.documentTypeId,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "LoginID": loginID,
        "Document": document,
        "DocumentTypeID": documentTypeId,
        "Description": description,
        "DeviceID": Constants.deviceID,
      };
}
