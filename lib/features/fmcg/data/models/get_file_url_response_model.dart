import 'package:tradologie_app/features/fmcg/domain/entities/get_file_url_response.dart';

class GetFileUrlResponseModel extends GetFileUrlResponse {
  const GetFileUrlResponseModel({
    super.fileUrl,
    super.fileName,
    super.contentType,
    super.fileSize,
  });

  factory GetFileUrlResponseModel.fromJson(Map<String, dynamic> json) =>
      GetFileUrlResponseModel(
        fileUrl: json["fileURL"],
        fileName: json["fileName"],
        contentType: json["contentType"],
        fileSize: json["fileSize"],
      );
}
