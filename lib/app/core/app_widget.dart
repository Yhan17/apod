import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'extensions/context_extension.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.loc.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: AppRoutes.builders,
      initialRoute: AppRoutes.home.path,
      theme: AppTheme.nasaTheme,
      darkTheme: AppTheme.nasaDarkTheme,
    );
  }
}
