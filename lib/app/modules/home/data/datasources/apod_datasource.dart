import 'dart:convert';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/http/nasa_apod_http_client.dart';
import '../../../../core/utils/app_pipes.dart';

abstract class ApodDatasource {
  Future<Result<ApodEntity, HttpFailure>> getApod({DateTime? date});
  Future<Result<Unit, Exception>> saveApod(ApodEntity? apod);
}

class ApodDatasourceImpl implements ApodDatasource {
  final NasaApodClient _client;
  final HiveInterface _hive;
  final String _boxName = 'apods';
  Box<ApodEntity>? _box;

  ApodDatasourceImpl(
    this._client,
    this._hive,
  );

  Future<void> _ensureBoxOpen() async {
    if (!_hive.isBoxOpen(_boxName)) {
      _box = await _hive.openBox<ApodEntity>(_boxName);
      log(name: 'APOD-DATABASE', 'Hive box "$_boxName" aberta.');
    } else {
      _box = _hive.box<ApodEntity>(_boxName);
    }
  }

  @override
  Future<Result<ApodEntity, HttpFailure>> getApod({DateTime? date}) async {
    await _ensureBoxOpen();
    try {
      final uri = Uri(path: '/planetary/apod', queryParameters: {
        if (date != null) 'date': AppPipes.formatDate(date),
      });

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final apodEntity = ApodEntity.fromJson(data);
        return Success(apodEntity);
      } else {
        return Error(AppPipes.handleHttpError(response.statusCode));
      }
    } catch (_) {
      return Error(HttpFailure.unknown);
    }
  }

  @override
  Future<Result<Unit, Exception>> saveApod(ApodEntity? apod) async {
    await _ensureBoxOpen();
    try {
      if (apod == null) {
        log(
          name: 'APOD-DATABASE',
          'Não foi possível salvar o APOD na base de dados, pois ele é nulo.',
        );
        return Error(Exception('APOD é nulo.'));
      }

      final key = AppPipes.formatDate(apod.date);

      if (_box!.containsKey(key)) {
        log(name: 'APOD-DATABASE', 'APOD já está salvo na base de dados.');
        return Error(Exception('APOD já está salvo na base de dados.'));
      }

      await _box!.put(key, apod);
      log(name: 'APOD-DATABASE', 'APOD salvo com sucesso na base de dados.');
      return const Success(unit);
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro ao salvar APOD na base de dados: $e',
      );
      return Error(Exception('Erro ao salvar APOD na base de dados: $e'));
    }
  }
}
