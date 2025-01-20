import 'dart:developer';

import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/types/view_model_type.dart';
import '../../domain/home_domain.dart';
import '../common/favorite_button_label.dart';

class HomeViewModel extends ViewModel {
  final GetApodUsecase _usecase;
  final SaveApodUsecase _saveApodUsecase;
  final IsPodSavedUsecase _isPodSavedUsecase;
  final RemoveApodFromHomeUseCase _removeApodFromHomeUseCase;
  final TranslateTextService? _translationService;

  ApodEntity? _apod;
  String? _errorMessage;
  FavoriteButtonLabel _buttonLabel = FavoriteButtonLabel.empty;

  HomeViewModel(
    this._usecase,
    this._saveApodUsecase,
    this._isPodSavedUsecase,
    this._removeApodFromHomeUseCase,
    this._translationService,
  );

  ApodEntity? get apod => _apod;
  String? get errorMessage => _errorMessage;
  FavoriteButtonLabel get buttonLabel => _buttonLabel;

  set apod(ApodEntity? value) {
    _apod = value;
    notifyListeners();
  }

  Future<void> fetchApod({DateTime? date}) async {
    await executeWithLoading(() async {
      _errorMessage = null;
      try {
        final result = await _usecase(date: date);
        switch (result) {
          case Success<ApodEntity, HttpFailure>():
            _apod = result.success;
            await isApodSaved();

            if (_translationService != null) {
              await translateApod();
            }
            break;
          case Error<ApodEntity, HttpFailure>():
            _errorMessage = result.error.message;
            break;
        }
      } catch (e) {
        _errorMessage = 'Erro ao buscar APOD: $e';
      }
    });
  }

  Future<bool> isApodSaved() async {
    bool resultValue = false;
    try {
      final result = await _isPodSavedUsecase(_apod!);
      if (result) {
        _buttonLabel = FavoriteButtonLabel.unfavorite;
        resultValue = true;
      } else {
        _buttonLabel = FavoriteButtonLabel.favorite;
      }
    } catch (e) {
      _buttonLabel = FavoriteButtonLabel.error;
    }
    notifyListeners();
    return resultValue;
  }

  Future<void> translateApod() async {
    if (_apod == null) {
      _errorMessage = 'APOD não disponível para tradução.';
      notifyListeners();
      return;
    }

    try {
      final result = await _translationService!.translateApodEntity(_apod!);
      switch (result) {
        case Success<ApodEntity, Unit>():
          _apod = result.success;
          log('APOD traduzido com sucesso.');
        case Error<ApodEntity, Unit>():
          log('Erro ao realizar a tradução');
      }
    } catch (e) {
      _errorMessage = 'Erro ao traduzir o APOD: $e';
      log('Erro ao traduzir o APOD: $e');
    }

    notifyListeners();
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
        (error) async {
          log(
            name: 'APOD-DATABASE',
            'Erro ao salvar APOD na base de dados: ${error.toString()}',
          );
          await isApodSaved();

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
        (error) async {
          log(
            name: 'APOD-DATABASE',
            'Erro ao remover APOD na base de dados: ${error.toString()}',
          );
          await isApodSaved();

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
