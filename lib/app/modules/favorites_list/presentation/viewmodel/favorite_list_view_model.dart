import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../domain/favorite_list_domain.dart';

class FavoriteListViewModel extends ChangeNotifier with LoadingMixin {
  final GetFavoriteListUsecase _getFavoriteListUsecase;
  List<ApodEntity> _favorites = [];
  String? _errorMessage;

  List<ApodEntity> get favorites => _favorites;
  String? get errorMessage => _errorMessage;

  FavoriteListViewModel(this._getFavoriteListUsecase);

  Future<void> fetchStoredApods() async {
    await executeWithLoading(() async {
      final result = await _getFavoriteListUsecase();
      switch (result) {
        case Success<List<ApodEntity>, Exception>():
          _favorites = result.success;
          notifyListeners();
          break;
        case Error<List<ApodEntity>, Exception>():
          _errorMessage = '${result.error}';
          notifyListeners();
          break;
      }
    });
  }
}
