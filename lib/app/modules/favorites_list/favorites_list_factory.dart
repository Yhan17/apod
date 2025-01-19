import 'package:flutter/material.dart';

import 'data/datasources/favorite_list_datasource.dart';
import 'data/repositories/favorite_list_repository_impl.dart';
import 'domain/usecases/get_favorite_list_usecase.dart';
import 'presentation/favorites_list_presentation.dart';
import 'presentation/viewmodel/favorite_list_view_model.dart';

class FavoritesListFactory {
  static FavoriteListViewModel? _viewModel;

  static Widget createPage() {
    _viewModel ??= _buildViewModel();

    return FavoritesListPage(
      viewModel: _viewModel!,
    );
  }

  static FavoriteListViewModel _buildViewModel() {
    final datasource = FavoriteListDatasourceImpl();
    final repository = FavoriteListRepositoryImpl(datasource);
    final useCase = GetFavoriteListUsecase(repository);

    return FavoriteListViewModel(useCase);
  }

  static void reset() {
    _viewModel = null;
  }
}
