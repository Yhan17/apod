import 'package:flutter/widgets.dart';

import '../../../../core/extensions/context_extension.dart';

enum FavoriteButtonLabel {
  favorite,
  unfavorite,
  empty,
  error;
}

extension FavoriteButtonLabelExtension on FavoriteButtonLabel {
  String getLabel(BuildContext context) {
    final strings = context.loc;
    switch (this) {
      case FavoriteButtonLabel.favorite:
        return strings.favorite;
      case FavoriteButtonLabel.unfavorite:
        return strings.unfavorite;
      case FavoriteButtonLabel.error:
        return strings.error;
      case FavoriteButtonLabel.empty:
        return strings.empty;
    }
  }
}
