import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/entities/apod_entity.dart';
import 'data/favorite_details_data.dart';
import 'domain/favorite_details_domain.dart';
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
    final hive = Hive;
    final service = SaveApodInHomeServiceImpl();

    final datasource = RemoveApodDatasourceImpl(hive);
    final repository = RemoveApodRepositoryImpl(datasource);
    final usecase = RemoveApodUseCase(repository);

    return FavoriteDetailViewModel(
      apod: apod,
      saveApodInHomeService: service,
      removeApodUseCase: usecase,
    );
  }

  static void reset() {
    _viewModel = null;
  }
}
