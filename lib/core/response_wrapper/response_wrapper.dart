import 'package:equatable/equatable.dart';

class ResponseWrapper<T> extends Equatable {
  final T data;
  final int? code;
  final bool success;
  final String message;

  const ResponseWrapper({
    required this.data,
    required this.code,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [
        data,
        code,
        success,
        message,
      ];
  Map<String, dynamic> toJson() => {
        "data": data,
        "code": code,
        "success": success,
        "message": message,
      };
}
