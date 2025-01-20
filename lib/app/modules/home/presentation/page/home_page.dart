import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/templates/base_page.dart';
import '../../../../core/components/content_component.dart';
import '../viewmodel/home_view_model.dart';
import '../widgets/bottom_actions_widget.dart';
import '../widgets/custom_error_widget.dart';

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
        title: Text(
          context.loc.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              AppRoutes.favoriteList.push(context);
            },
          ),
        ],
      ),
      body: _BodyWidget(viewModel: viewModel),
      bottomNavigationBar: BottomActionsWidget(
        buttonLabel: viewModel.buttonLabel,
        onDateChange: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1995, 6, 16),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            viewModel.fetchApod(date: selectedDate);
          }
        },
        onFavorite: () async {
          final isApodAlreadySaved = await viewModel.isApodSaved();
          if (isApodAlreadySaved) {
            final message = await viewModel.removeApodFromDatabase();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          } else {
            final message = await viewModel.saveApodToDatabase();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          }
        },
      ),
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

    return ContentComponent(apod: viewModel.apod);
  }
}
