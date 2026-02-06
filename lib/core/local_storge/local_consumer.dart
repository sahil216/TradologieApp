import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../response_wrapper/response_wrapper.dart';
import '../response_wrapper/response_wrapper_model.dart';

abstract class LocalConsumer {
  Future<dynamic> get(String fileName);
  Future<dynamic> add(String fileName, ResponseWrapper<dynamic> data);
  Future<dynamic> delete(String fileName);
}

class LocalConsumerImpl implements LocalConsumer {
  final SharedPreferences sharedPreferences;
  final Directory applicationDocumentsDirectory;
  LocalConsumerImpl(
      {required this.sharedPreferences,
      required this.applicationDocumentsDirectory});

  @override
  Future add(String fileName, ResponseWrapper<dynamic> data) async {
    String path = '${applicationDocumentsDirectory.path}/local_storage';
    Directory directory = Directory(path);
    if (!await directory.exists()) await directory.create();
    File newTextFile = File('$path/$fileName.txt');
    await newTextFile.writeAsString(jsonEncode(data.toJson()));
    await sharedPreferences.setBool(fileName, true);
  }

  @override
  Future get(String fileName) async {
    String path =
        '${applicationDocumentsDirectory.path}/local_storage/$fileName.txt';
    File newTextFile = File(path);
    if (!await newTextFile.exists()) {
      return null;
    }
    String content = await newTextFile.readAsString();
    return ResponseWrapperModel<dynamic>.fromJson(jsonDecode(content));
  }

  @override
  Future delete(String fileName) async {
    String path =
        '${applicationDocumentsDirectory.path}/local_storage/$fileName.txt';
    File newTextFile = File(path);
    if (await newTextFile.exists()) {
      await newTextFile.delete();
    }
  }
}
