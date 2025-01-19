import 'package:flutter/material.dart';

import '../../../../core/entities/apod_entity.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/zoomable_image_widget.dart';

class MultiMediaComponent extends StatelessWidget {
  final ApodEntity apod;

  const MultiMediaComponent({super.key, required this.apod});

  @override
  Widget build(BuildContext context) {
    if (apod.mediaType == MediaType.image) {
      return ZoomableImageWidget(imageUrl: apod.url);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: VideoPlayerWidget(videoUrl: apod.url),
      );
    }
  }
}
