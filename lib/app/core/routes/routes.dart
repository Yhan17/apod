import 'package:flutter/material.dart';

import '../../modules/favorites_details/favorite_details_factory.dart';
import '../../modules/favorites_list/favorites_list_factory.dart';
import '../../modules/home/home_factory.dart';
import '../entities/apod_entity.dart';

part 'page_router.dart';

abstract class AppRoutes {
  static const home = PageRoute<NoArgs>('/home');
  static const favoriteList = PageRoute<NoArgs>('/favorites');
  static const favoriteDetails = PageRoute<ApodEntity>('/favorites-details');

  static final Map<String, WidgetBuilder> builders = {
    home.path: (_) => HomeFactory.createPage(),
    favoriteList.path: (_) => FavoritesListFactory.createPage(),
    favoriteDetails.path: (context) {
      final apod = _argumentsOf<ApodEntity>(context);
      return FavoritesDetailsFactory.createPage(apod);
    }
  };

  static T _argumentsOf<T>(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! T) {
      throw ArgumentError(
        'Argumentos da rota são inválidos ou não correspondem ao esperado: $T.',
      );
    }
    return args;
  }
}
