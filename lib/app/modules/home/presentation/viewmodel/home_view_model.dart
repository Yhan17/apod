import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../domain/home_domain.dart';
import '../common/favorite_button_label.dart';

class HomeViewModel extends ChangeNotifier with LoadingMixin {
  final GetApodUsecase _usecase;
  final SaveApodUsecase _saveApodUsecase;
  final IsPodSavedUsecase _isPodSavedUsecase;
  final RemoveApodFromHomeUseCase _removeApodFromHomeUseCase;

  ApodEntity? _apod;
  String? _errorMessage;
  FavoriteButtonLabel _buttonLabel = FavoriteButtonLabel.empty;

  HomeViewModel(
    this._usecase,
    this._saveApodUsecase,
    this._isPodSavedUsecase,
    this._removeApodFromHomeUseCase,
  );

  ApodEntity? get apod => _apod;
  String? get errorMessage => _errorMessage;
  FavoriteButtonLabel get buttonLabel => _buttonLabel;

  Future<void> fetchApod({DateTime? date}) async {
    await executeWithLoading(() async {
      _errorMessage = null;
      try {
        final result = await _usecase(date: date);
        switch (result) {
          case Success<ApodEntity, HttpFailure>():
            _apod = result.success;
            await isApodSaved();
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
    try {
      final result = await _isPodSavedUsecase(_apod!);
      if (result) {
        _buttonLabel = FavoriteButtonLabel.unfavorite;
        notifyListeners();
        return true;
      }
      _buttonLabel = FavoriteButtonLabel.favorite;
      notifyListeners();

      return false;
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro inesperado ao verificar se o APOD já está salvo: $e',
      );
      _buttonLabel = FavoriteButtonLabel.error;
      notifyListeners();
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
        (success) async {
          log(
              name: 'APOD-DATABASE',
              'APOD salvo com sucesso na base de dados.');
          await isApodSaved();

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

  Future<String> removeApodFromDatabase() async {
    if (_apod == null) {
      log(
        name: 'APOD-DATABASE',
        'Não foi possível salvar o APOD na base de dados, pois ele é nulo.',
      );
      return 'Não foi possível salvar o APOD na base de dados, pois ele é nulo.';
    }

    try {
      final result = await _removeApodFromHomeUseCase(_apod!);

      return result.when(
        (success) async {
          log(
              name: 'APOD-DATABASE',
              'APOD removido com sucesso na base de dados.');
          await isApodSaved();

          return 'APOD removido com sucesso na base de dados.';
        },
        (error) {
          log(
            name: 'APOD-DATABASE',
            'Erro ao remover APOD na base de dados: ${error.toString()}',
          );
          return 'Erro ao remover APOD na base de dados: ${error.toString()}';
        },
      );
    } catch (e) {
      log(
        name: 'APOD-DATABASE',
        'Erro inesperado ao remover APOD: $e',
      );
      return 'Erro inesperado ao remover APOD: $e';
    }
  }
}
