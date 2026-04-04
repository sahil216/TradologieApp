import 'package:equatable/equatable.dart';

class GetFileUrlResponse extends Equatable {
  final String? fileUrl;
  final String? fileName;
  final String? contentType;
  final String? fileSize;

  const GetFileUrlResponse({
    this.fileUrl,
    this.fileName,
    this.contentType,
    this.fileSize,
  });

  @override
  List<Object?> get props => [fileUrl, fileName, contentType, fileSize];
}
