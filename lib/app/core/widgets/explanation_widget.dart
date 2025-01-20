import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../extensions/context_extension.dart';

class ExplanationWidget extends StatefulWidget {
  final String? text;

  const ExplanationWidget({
    super.key,
    required this.text,
  });

  @override
  State<ExplanationWidget> createState() => ExplanationWidgetState();
}

class ExplanationWidgetState extends State<ExplanationWidget> {
  @override
  Widget build(BuildContext context) {
    final isLoading = context.isLoading;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Skeletonizer(
        enabled: isLoading,
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: isLoading
                      ? _buildSkeletonText(context)
                      : Text(
                          widget.text ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.justify,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(6, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: index == 4 ? 0 : 8),
          width: double.infinity,
          height: 16,
          color: Colors.grey[300],
        );
      }),
    );
  }
}
