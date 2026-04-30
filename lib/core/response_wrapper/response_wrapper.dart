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
/*

class ResponseWrapperFMCGSeller<T> extends Equatable {
  final T data;
  final int success;
  final String message;

  const ResponseWrapperFMCGSeller({
    required this.data,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [
        data,
        success,
        message,
      ];
  Map<String, dynamic> toJson() => {
        "detail": data,
        "success": success,
        "message": message,
      };
}*/


class ResponseWrapperFMCGSeller<T> extends Equatable {
  final T data;
  final int success;
  final String message;

  const ResponseWrapperFMCGSeller({
    required this.data,
    required this.message,
    required this.success,
  });

  factory ResponseWrapperFMCGSeller.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return ResponseWrapperFMCGSeller<T>(
      data: fromJsonT(json["detail"]),
      success: json["success"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson(
      Map<String, dynamic> Function(T value) toJsonT,
      ) =>
      {
        "detail": toJsonT(data),
        "success": success,
        "message": message,
      };

  @override
  List<Object?> get props => [data, success, message];
}

