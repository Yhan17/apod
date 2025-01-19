import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ZoomableImageWidget extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                imageBuilder: (ctx, imageProvider) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth,
                      maxHeight: constraints.maxHeight,
                    ),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  );
                },
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}