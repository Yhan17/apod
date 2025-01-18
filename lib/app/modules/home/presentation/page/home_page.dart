// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../../../../core/templates/base_page.dart';
import '../viewmodel/home_view_model.dart';

class HomePage extends BasePage<HomeViewModel> {
  const HomePage({
    Key? key,
    required HomeViewModel viewModel,
  }) : super(key: key, viewModel: viewModel);

  @override
  Widget buildPage(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APOD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (viewModel.errorMessage != null)
              Text(viewModel.errorMessage!)
            else if (viewModel.apod != null)
              Column(
                children: [
                  Text(viewModel.apod!.title),
                  Image.network(viewModel.apod!.url),
                ],
              ),
            ElevatedButton(
              onPressed: () => viewModel.fetchApod(),
              child: Text('Buscar APOD'),
            ),
          ],
        ),
      ),
    );
  }
}
