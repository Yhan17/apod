import 'dart:developer';

import 'package:hive/hive.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/utils/app_pipes.dart';

abstract class SavedApodDatasource {
  Future<bool> isApodSaved(ApodEntity? apod);
}

class SavedApodDatasourceImpl implements SavedApodDatasource {
  final String _boxName = 'apods';
  final HiveInterface _hive;
  Box<ApodEntity>? _box;

  SavedApodDatasourceImpl(this._hive);

  Future<void> _ensureBoxOpen() async {
    if (!_hive.isBoxOpen(_boxName)) {
      _box = await _hive.openBox<ApodEntity>(_boxName);
      log(name: 'APOD-DATABASE', 'Hive box "$_boxName" aberta.');
    } else {
      _box = _hive.box<ApodEntity>(_boxName);
    }
  }

  @override
  Future<bool> isApodSaved(ApodEntity? apod) async {
    if (apod == null) {
      log(
        name: 'APOD-DATABASE',
        'Não é possível verificar, pois o APOD é nulo.',
      );
      return false;
    }

    await _ensureBoxOpen();
    try {
      final key = AppPipes.formatDate(apod.date);
      return _box!.containsKey(key);
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro ao verificar se o APOD já está salvo: $e',
      );
      return false;
    }
  }
}
