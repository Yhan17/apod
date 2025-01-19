import 'package:flutter/material.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/mixins/loading_mixin.dart';
import '../../domain/favorite_details_domain.dart';

class FavoriteDetailViewModel extends ChangeNotifier with LoadingMixin {
  final SaveApodInHomeService saveApodInHomeService;
  final ApodEntity apod;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FavoriteDetailViewModel({
    required this.apod,
    required this.saveApodInHomeService,
  });

  Future<void> saveApodInHome() async {
    executeWithLoading(() async {
      await saveApodInHomeService(apod);
    });
  }
}
