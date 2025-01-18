import '../../core/environment/environment.dart';
import '../../core/http/nasa_apod_http_client.dart';

import 'data/home_data.dart';
import 'domain/home_domain.dart';
import 'package:flutter/material.dart';

import 'presentation/home_presentation.dart';
import 'presentation/page/home_page.dart';

class HomeFactory {
  static Widget createPage({DateTime? date}) {
    final client = NasaApodClient(
      baseUrl: Environment.baseUrl,
      apiKey: Environment.apiKey,
    );

    final datasource = ApodDatasourceImpl(client);
    final repository = ApodRepositoryImpl(datasource);
    final useCase = GetApodUsecase(repository);
    final viewModel = HomeViewModel(useCase);

    return HomePage(viewModel: viewModel);
  }
}
