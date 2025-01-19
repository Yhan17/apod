import 'package:flutter/material.dart';

import '../../core/entities/apod_entity.dart';
import 'data/favorite_details_data.dart';
import 'presentation/favorite_details_presentation.dart';

class FavoritesDetailsFactory {
  static FavoriteDetailViewModel? _viewModel;

  static Widget createPage(ApodEntity apod) {
    _viewModel ??= _buildViewModel(apod);

    return FavoriteDetailsPage(
      viewModel: _viewModel!,
      onBack: () {
        reset();
      },
    );
  }

  static FavoriteDetailViewModel _buildViewModel(ApodEntity apod) {
    final service = SaveApodInHomeServiceImpl();

    return FavoriteDetailViewModel(
      apod: apod,
      saveApodInHomeService: service,
    );
  }

  static void reset() {
    _viewModel = null;
  }
}
