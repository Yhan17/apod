import 'package:flutter/material.dart';

import '../../../../core/templates/base_page.dart';
import '../../../../core/components/content_component.dart';
import '../viewmodel/home_view_model.dart';
import '../widgets/bottom_actions_widget.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/loading_widget.dart';

class HomePage extends BasePage<HomeViewModel> {
  const HomePage({
    super.key,
    required super.viewModel,
  });

  @override
  void onPageLoad(BuildContext context, HomeViewModel viewModel) {
    super.onPageLoad(context, viewModel);
    viewModel.fetchApod();
  }

  @override
  Widget buildPage(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NASA APOD', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
      ),
      body: _BodyWidget(viewModel: viewModel),
      bottomNavigationBar: BottomActionsWidget(viewModel: viewModel),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  final HomeViewModel viewModel;

  const _BodyWidget({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.errorMessage != null) {
      return CustomErrorWidget(errorMessage: viewModel.errorMessage!);
    }

    if (viewModel.apod == null) {
      return const LoadingWidget();
    }

    return ContentComponent(apod: viewModel.apod!);
  }
}
