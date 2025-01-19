import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/templates/base_page.dart';
import '../../../../core/utils/app_pipes.dart';
import '../viewmodel/favorite_list_view_model.dart';
import '../widgets/card_video_player_widget.dart';

class FavoritesListPage extends BasePage<FavoriteListViewModel> {
  const FavoritesListPage({super.key, required super.viewModel});

  @override
  void onPageLoad(BuildContext context, FavoriteListViewModel viewModel) {
    super.onPageLoad(context, viewModel);
    viewModel.fetchStoredApods();
  }

  @override
  Widget buildPage(BuildContext context, FavoriteListViewModel viewModel) {
    if (viewModel.favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('APODs Salvos'),
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: Text('Nenhum APOD salvo ainda')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APODs Salvos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: viewModel.favorites.length,
        itemBuilder: (context, index) {
          final apod = viewModel.favorites[index];
          return _buildApodCard(context, apod);
        },
      ),
    );
  }

  Widget _buildApodCard(BuildContext context, ApodEntity apod) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: _buildMediaThumb(context, apod),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apod.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  AppPipes.formatDate(apod.date, format: 'dd/MM/yyyy'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
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
        placeholder: (ctx, url) => const Center(
          child: CircularProgressIndicator(),
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
}
