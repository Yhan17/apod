import 'package:hive_flutter/hive_flutter.dart';
import '../entities/apod_entity.dart';

class HiveConfig {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ApodEntityImplAdapter());
  }
}
