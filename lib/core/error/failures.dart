import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Failure extends Equatable implements Exception {
  final String? msg;
  final int? code;

  Failure(this.msg, this.code) {
    if (kDebugMode) {
      print("Failure: $msg");
    }
  }

  @override
  List<Object?> get props => [msg, code];
}
