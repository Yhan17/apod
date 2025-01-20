import 'package:flutter/material.dart';

import '../../types/view_model_type.dart';

class LoadingNotifier extends InheritedNotifier<ChangeNotifier> {
  const LoadingNotifier({
    super.key,
    required ChangeNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static bool of(BuildContext context) {
    final notifier =
        context.dependOnInheritedWidgetOfExactType<LoadingNotifier>();
    return (notifier?.notifier as ViewModel?)?.isLoading ?? false;
  }
}
