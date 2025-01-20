import 'package:hive/hive.dart';

import '../../core/environment/environment.dart';
import '../../core/http/nasa_apod_http_client.dart';

import 'data/home_data.dart';
import 'domain/home_domain.dart';
import 'package:flutter/material.dart';

import 'presentation/home_presentation.dart';
import 'presentation/page/home_page.dart';

class HomeFactory {
  static HomeViewModel? _viewModel;

  static Widget createPage({DateTime? date}) {
    _viewModel ??= _buildViewModel();

    if (date != null) {
      _viewModel!.fetchApod(date: date);
    }

    return HomePage(viewModel: _viewModel!);
  }

  static HomeViewModel _buildViewModel() {
    final client = NasaApodClient(
      baseUrl: Environment.baseUrl,
      apiKey: Environment.apiKey,
    );
    final hive = Hive;

    final datasource = ApodDatasourceImpl(client, hive);
    final savedDatasource = SavedApodDatasourceImpl(hive);
    final removeDatasource = RemoveApodFromHomeDatasourceImpl(hive);

    final repository = ApodRepositoryImpl(datasource);
    final savedRepository = IsSavedApodRepositoryImpl(savedDatasource);
    final removeRepository = RemoveApodFromHomeRepositoryImpl(removeDatasource);

    final useCase = GetApodUsecase(repository);
    final saveApodUseCase = SaveApodUsecase(repository);
    final isPodSavedUsecase = IsPodSavedUsecase(savedRepository);
    final removeApodUseCase = RemoveApodFromHomeUseCase(removeRepository);

    return HomeViewModel(
      useCase,
      saveApodUseCase,
      isPodSavedUsecase,
      removeApodUseCase,
    );
  }

  static void reset() {
    _viewModel = null;
  }
}
