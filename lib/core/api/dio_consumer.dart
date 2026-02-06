import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../injection_container.dart';
import '../error/auth_failure.dart';
import '../error/network_failure.dart';
import '../error/server_failure.dart';
import '../error/user_failure.dart';
import 'api_consumer.dart';
import 'app_interceptors.dart';
import 'end_points.dart';
import '../response_wrapper/response_wrapper.dart';
import 'status_code.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;
  final InternetConnectionChecker networkInfo;

  DioConsumer({required this.client, required this.networkInfo}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return httpClient;
    };

    client.options
      ..baseUrl = EndPoints.baseUrlSupplier
      ..responseType = ResponseType.plain
      ..maxRedirects = 10
      ..followRedirects = false
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(sl<LogInterceptor>());
    }
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.post(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await client.put(path, queryParameters: queryParameters, data: body);
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.delete(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    late ResponseWrapper<dynamic> res;
    final responseJson = jsonDecode(response.data.toString());
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        responseJson["success"] == 1) {
      if (responseJson["totalPages"] != null) {
        res = ResponseWrapper<dynamic>(
          data: responseJson,
          code: response.statusCode,
          message: responseJson["message"] ?? "",
          success: true,
        );
      } else {
        res = ResponseWrapper<dynamic>(
          data: responseJson["detail"],
          code: response.statusCode,
          message: responseJson["message"] ?? "",
          success: true,
        );
      }
    } else {
      res = ResponseWrapper<dynamic>(
        data: responseJson["detail"],
        code: response.statusCode,
        message: responseJson["message"] ?? "",
        success: false,
      );
    }
    return res;
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw NetworkFailure("connection time out", error.response?.statusCode);
      case DioExceptionType.sendTimeout:
        throw NetworkFailure("send time out", error.response?.statusCode);
      case DioExceptionType.receiveTimeout:
        throw NetworkFailure("receive time out", error.response?.statusCode);
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            final message = error.response?.data["message"];
            if (message != null && message.isNotEmpty) {
              throw UserFailure(message, error.response?.statusCode);
            }
            throw ServerFailure("bad request", error.response?.statusCode);
          case StatusCode.unauthorized:
            throw AuthFailure("unauthorized", error.response?.statusCode);
          case StatusCode.forbidden:
            throw AuthFailure("forbidden", error.response?.statusCode);
          case StatusCode.notFound:
            throw ServerFailure("not found", error.response?.statusCode);
          case StatusCode.confilct:
            throw ServerFailure("confilct", error.response?.statusCode);
          case StatusCode.internalServerError:
            throw ServerFailure(
                "internal server error", error.response?.statusCode);
        }
        break;
      case DioExceptionType.cancel:
        throw ServerFailure("cancel", error.response?.statusCode);
      case DioExceptionType.unknown:
        throw NetworkFailure("unknown", error.response?.statusCode);
      case DioExceptionType.badCertificate:
        throw ServerFailure("bad certificate", error.response?.statusCode);
      case DioExceptionType.connectionError:
        throw NetworkFailure("connection error", error.response?.statusCode);
    }
  }
}
