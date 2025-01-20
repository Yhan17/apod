import 'dart:developer';

import 'package:multiple_result/multiple_result.dart';
import 'package:hive/hive.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/utils/app_pipes.dart';

abstract class RemoveApodFromHomeDatasource {
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod);
}

class RemoveApodFromHomeDatasourceImpl implements RemoveApodFromHomeDatasource {
  final String _boxName = 'apods';
  final HiveInterface _hive;
  Box<ApodEntity>? _box;

  RemoveApodFromHomeDatasourceImpl(this._hive);

  Future<void> _ensureBoxOpen() async {
    if (!_hive.isBoxOpen(_boxName)) {
      _box = await _hive.openBox<ApodEntity>(_boxName);
      log(name: 'APOD-DATABASE', 'Hive box "$_boxName" aberta.');
    } else {
      _box = _hive.box<ApodEntity>(_boxName);
    }
  }

  @override
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod) async {
    await _ensureBoxOpen();
    try {
      final key = AppPipes.formatDate(apod.date);
      if (_box!.containsKey(key)) {
        await _box!.delete(key);
        log(
            name: 'APOD-DATABASE',
            'APOD removido com sucesso na base de dados.');
        return const Success(unit);
      } else {
        log(name: 'APOD-DATABASE', 'APOD não está salvo na base de dados.');
        return Error(Exception('APOD não está salvo na base de dados.'));
      }
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro ao remover APOD na base de dados: $e',
      );
      return Error(Exception('Failed to remove APOD: $e'));
    }
  }
}
