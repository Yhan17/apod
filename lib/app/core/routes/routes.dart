import 'package:flutter/material.dart';

import '../../modules/home/home_factory.dart';

part 'page_router.dart';

abstract class AppRoutes {
  static const home = PageRoute<NoArgs>('/home');

  static Map<String, WidgetBuilder> get builders => {
        home.path: (_) => HomeFactory.createPage(),
      };

  // ignore: unused_element
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
