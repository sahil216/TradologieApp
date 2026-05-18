import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

import 'main_app.dart';

Future<void> main() async {
  await di.init();
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  if (kReleaseMode) {
    ErrorWidget.builder = (_) {
      return const SizedBox.shrink();
    };
  }
  runApp(const MainApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
