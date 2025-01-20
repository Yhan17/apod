import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../templates/notifiers/loading_notifier.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

extension MediaQueryExtension on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;
}

extension LoadingNotifierExtension on BuildContext {
  bool get isLoading => LoadingNotifier.of(this);
}
