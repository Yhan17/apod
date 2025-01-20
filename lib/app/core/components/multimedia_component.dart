import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../entities/apod_entity.dart';
import '../extensions/context_extension.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/zoomable_image_widget.dart';

class MultiMediaComponent extends StatelessWidget {
  final ApodEntity? apod;

  const MultiMediaComponent({super.key, required this.apod});

  @override
  Widget build(BuildContext context) {
    if (apod == null) {
      return _buildSkeleton(context);
    }
    if (apod!.mediaType == MediaType.image) {
      return ZoomableImageWidget(imageUrl: apod!.url);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: VideoPlayerWidget(videoUrl: apod!.url),
      );
    }
  }

  Widget _buildSkeleton(BuildContext context) {
    return Skeleton.leaf(
      enabled: context.isLoading,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
