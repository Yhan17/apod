import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../extensions/context_extension.dart';

class ZoomableImageWidget extends StatelessWidget {
  final String imageUrl;

  const ZoomableImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.isLoading;

    return SafeArea(
      child: Skeletonizer(
        enabled: isLoading,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(Icons.image),
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      context.loc.imageErrorLoading,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ZoomableImageWidget(
                              imageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Text(context.loc.tryAgain),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
