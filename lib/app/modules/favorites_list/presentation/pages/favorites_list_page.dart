import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/templates/base_page.dart';
import '../../../../core/utils/app_pipes.dart';
import '../viewmodel/favorite_list_view_model.dart';
import '../widgets/card_video_player_widget.dart';

class FavoritesListPage extends BasePage<FavoriteListViewModel> {
  const FavoritesListPage({super.key, required super.viewModel});

  @override
  void onPageAppear(BuildContext context, FavoriteListViewModel viewModel) {
    super.onPageAppear(context, viewModel);
    viewModel.fetchStoredApods();
  }

  @override
  Widget buildPage(BuildContext context, FavoriteListViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Skeletonizer(
        enabled: context.isLoading,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: viewModel.favorites.length,
          itemBuilder: (context, index) {
            final apod = viewModel.favorites[index];
            return _buildApodCard(context, apod);
          },
        ),
      ),
    );
  }

  Widget _buildApodCard(BuildContext context, ApodEntity apod) {
    return GestureDetector(
      onTap: apod.mediaType == MediaType.image
          ? () => _navigateToDetailsPage(context, apod)
          : null,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: _buildMediaThumb(context, apod),
            ),
            GestureDetector(
              onTap: () => _navigateToDetailsPage(context, apod),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apod.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppPipes.formatDate(apod.date, format: 'dd/MM/yyyy'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaThumb(BuildContext context, ApodEntity apod) {
    if (apod.mediaType == MediaType.image) {
      return CachedNetworkImage(
        imageUrl: apod.url,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        placeholder: (ctx, url) => Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(Icons.image),
          ),
        ),
        errorWidget: (ctx, url, error) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.error, size: 50, color: Colors.red),
        ),
      );
    } else {
      return CardVideoPlayerWidget(videoUrl: apod.url);
    }
  }

  void _navigateToDetailsPage(BuildContext context, ApodEntity apod) {
    AppRoutes.favoriteDetails.push(context, arguments: apod);
  }
}
