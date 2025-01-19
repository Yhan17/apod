import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/core/app_widget.dart';
import 'app/core/config/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AppWidget());
}
