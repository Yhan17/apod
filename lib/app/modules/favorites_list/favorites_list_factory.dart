import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'data/favorite_list_data.dart';
import 'domain/favorite_list_domain.dart';
import 'presentation/favorites_list_presentation.dart';

class FavoritesListFactory {
  static FavoriteListViewModel? _viewModel;

  static Widget createPage() {
    _viewModel ??= _buildViewModel();

    return FavoritesListPage(
      viewModel: _viewModel!,
    );
  }

  static FavoriteListViewModel _buildViewModel() {
    final hive = Hive;

    final datasource = FavoriteListDatasourceImpl(hive);
    final repository = FavoriteListRepositoryImpl(datasource);
    final useCase = GetFavoriteListUsecase(repository);

    return FavoriteListViewModel(useCase);
  }

  static void reset() {
    _viewModel = null;
  }
}
