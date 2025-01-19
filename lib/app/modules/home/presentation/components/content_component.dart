import 'package:flutter/material.dart';

import '../../../../core/entities/apod_entity.dart';
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
          // 1) Mídia (imagem/vídeo) com limite de altura
          Flexible(
            flex: 0, // ou um valor de flex se quiser dividir espaço
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300, // Ajuste conforme seu layout/design
              ),
              child: MultiMediaComponent(apod: apod),
            ),
          ),
          const SizedBox(height: 16),

          // 2) Título e Data
          TitleAndDateWidget(
            title: apod.title,
            date: apod.date,
          ),
          const SizedBox(height: 16),

          // 3) Explicação ocupando o espaço restante
          Expanded(
            child: ExplanationWidget(text: apod.explanation),
          ),
        ],
      ),
    );
  }
}
