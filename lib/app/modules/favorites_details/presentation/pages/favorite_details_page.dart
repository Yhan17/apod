import 'package:flutter/material.dart';

import '../../../../core/components/content_component.dart';
import '../../../../core/entities/apod_entity.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/templates/base_page.dart';
import '../viewmodel/favorite_detail_view_model.dart';
import '../widgets/details_bottom_action_widget.dart';

class FavoriteDetailsPage extends BasePage<FavoriteDetailViewModel> {
  final VoidCallback onBack;
  const FavoriteDetailsPage({
    super.key,
    required super.viewModel,
    required this.onBack,
  });

  @override
  void onPageDisappear(
    BuildContext context,
    FavoriteDetailViewModel viewModel,
  ) {
    super.onPageDisappear(context, viewModel);
    onBack();
  }

  @override
  Widget buildPage(BuildContext context, FavoriteDetailViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: _BodyWidget(viewModel: viewModel),
      bottomNavigationBar: DetailsBottomActionWidget(
        showTransformButton: viewModel.apod.mediaType == MediaType.image,
        onTransformWidget: () {
          viewModel.saveApodInHome();
        },
        onUnfavorite: () async {
          await viewModel.removeApod(
            () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  final FavoriteDetailViewModel viewModel;

  const _BodyWidget({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.errorMessage != null) {
      return SizedBox.shrink();
    }

    return ContentComponent(apod: viewModel.apod);
  }
}
