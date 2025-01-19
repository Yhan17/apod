import 'package:flutter/material.dart';

import '../entities/apod_entity.dart';
import '../widgets/explanation_widget.dart';
import '../widgets/title_and_date_widget.dart';
import 'multimedia_component.dart';

class ContentComponent extends StatelessWidget {
  final ApodEntity apod;

  const ContentComponent({super.key, required this.apod});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Flexible(
            flex: 0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: MultiMediaComponent(apod: apod),
            ),
          ),
          const SizedBox(height: 16),
          TitleAndDateWidget(
            title: apod.title,
            date: apod.date,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ExplanationWidget(text: apod.explanation),
          ),
        ],
      ),
    );
  }
}
