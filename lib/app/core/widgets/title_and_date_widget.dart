import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../extensions/context_extension.dart';
import '../utils/app_pipes.dart';

class TitleAndDateWidget extends StatelessWidget {
  final String? title;
  final DateTime? date;

  const TitleAndDateWidget({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = context.isLoading;

    return Skeletonizer(
      enabled: isLoading,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: isLoading
                ? _buildSkeletonTitle(context)
                : Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
          ),
          if (isLoading)
            _buildSkeletonDate(context)
          else
            Text(
              date != null
                  ? AppPipes.formatDate(date!, format: 'dd/MM/yyyy')
                  : '',
              style: Theme.of(context).textTheme.labelMedium,
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonTitle(BuildContext context) {
    return Container(
      height: 20,
      width: 200,
      color: Colors.grey[300],
      margin: const EdgeInsets.only(right: 8),
    );
  }

  Widget _buildSkeletonDate(BuildContext context) {
    return Container(
      height: 16,
      width: 100,
      color: Colors.grey[300],
    );
  }
}
