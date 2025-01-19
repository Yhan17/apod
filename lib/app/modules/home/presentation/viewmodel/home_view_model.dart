import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/mixins/loading_mixin.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_pipes.dart';
import '../../domain/home_domain.dart';

class HomeViewModel extends ChangeNotifier with LoadingMixin {
  final GetApodUsecase _usecase;
  final SaveApodUsecase _saveApodUsecase;

  ApodEntity? _apod;
  String? _errorMessage;

  HomeViewModel(this._usecase, this._saveApodUsecase);

  ApodEntity? get apod => _apod;
  String? get errorMessage => _errorMessage;

  Future<void> fetchApod({DateTime? date}) async {
    await executeWithLoading(() async {
      _errorMessage = null;
      try {
        final result = await _usecase(date: date);
        switch (result) {
          case Success<ApodEntity, HttpFailure>():
            _apod = result.success;
            break;
          case Error<ApodEntity, HttpFailure>():
            _errorMessage = '${result.error}';
            break;
        }
      } catch (e) {
        _errorMessage = 'Erro ao buscar APOD: $e';
      }
    });
  }

  Future<bool> isApodSaved() async {
    if (_apod == null) {
      log(
        name: 'APOD-DATABASE',
        'Não é possível verificar, pois o APOD é nulo.',
      );
      return false;
    }

    try {
      final box = await Hive.openBox<ApodEntity>('apods');
      final key = AppPipes.formatDate(_apod!.date);
      return box.containsKey(key);
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro ao verificar se o APOD já está salvo: $e',
      );
      return false;
    }
  }

  Future<String> saveApodToDatabase() async {
    if (_apod == null) {
      log(
        name: 'APOD-DATABASE',
        'Não foi possível salvar o APOD na base de dados, pois ele é nulo.',
      );
      return 'Não foi possível salvar o APOD na base de dados, pois ele é nulo.';
    }

    try {
      final result = await _saveApodUsecase(_apod);

      return result.when(
        (success) {
          log(
              name: 'APOD-DATABASE',
              'APOD salvo com sucesso na base de dados.');
          return 'APOD salvo com sucesso na base de dados.';
        },
        (error) {
          log(
            name: 'APOD-DATABASE',
            'Erro ao salvar APOD na base de dados: ${error.toString()}',
          );
          return 'Erro ao salvar APOD na base de dados: ${error.toString()}';
        },
      );
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro inesperado ao salvar APOD: $e',
      );
      return 'Erro inesperado ao salvar APOD: $e';
    }
  }
}
