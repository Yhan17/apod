import 'package:flutter/material.dart';

import '../mixins/loading_mixin.dart';

abstract class BasePage<VM extends ChangeNotifier> extends StatelessWidget {
  final VM viewModel;

  const BasePage({super.key, required this.viewModel});

  Widget buildPage(BuildContext context, VM viewModel);

  Widget buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        if (viewModel is LoadingMixin &&
            (viewModel as LoadingMixin).isLoading) {
          return buildLoading(context);
        }

        return buildPage(context, viewModel);
      },
    );
  }
}
