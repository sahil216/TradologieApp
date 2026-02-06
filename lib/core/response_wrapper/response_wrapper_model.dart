import 'response_wrapper.dart';

class ResponseWrapperModel<T> extends ResponseWrapper {
  const ResponseWrapperModel({
    required super.data,
    required super.code,
    required super.success,
    required super.message,
  });

  factory ResponseWrapperModel.fromJson(Map<String, dynamic> json) =>
      ResponseWrapperModel(
        data: json["data"],
        code: json["code"],
        success: json["success"],
        message: json["message"],
      );
}
