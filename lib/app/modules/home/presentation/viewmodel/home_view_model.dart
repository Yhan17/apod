import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/mixins/loading_mixin.dart';
import 'package:flutter/material.dart';

import '../../domain/home_domain.dart';

class HomeViewModel extends ChangeNotifier with LoadingMixin {
  final GetApodUsecase _usecase;

  ApodEntity? _apod;
  String? _errorMessage;

  HomeViewModel(this._usecase);

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
}
