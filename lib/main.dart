import 'package:flutter/material.dart';
import 'app/core/app_widget.dart';
import 'app/core/config/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveConfig.initialize();

  runApp(const AppWidget());
}
