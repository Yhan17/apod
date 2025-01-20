import 'package:flutter/material.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../domain/favorite_details_domain.dart';

class FavoriteDetailViewModel extends ChangeNotifier with LoadingMixin {
  final SaveApodInHomeService saveApodInHomeService;
  final RemoveApodUseCase removeApodUseCase;
  final ApodEntity apod;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FavoriteDetailViewModel({
    required this.apod,
    required this.saveApodInHomeService,
    required this.removeApodUseCase,
  });

  Future<void> saveApodInHome() async {
    executeWithLoading(() async {
      await saveApodInHomeService(apod);
    });
  }

  Future<void> removeApod(VoidCallback onRemove) async {
    executeWithLoading(() async {
      final result = await removeApodUseCase(apod);
      result.when(
        (_) {
          onRemove();
        },
        (error) {
          _errorMessage = error.toString();
          notifyListeners();
        },
      );
    });
  }
}
