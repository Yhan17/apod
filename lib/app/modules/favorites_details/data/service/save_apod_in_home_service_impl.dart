import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/utils/app_pipes.dart';
import '../../domain/favorite_details_domain.dart';

class SaveApodInHomeServiceImpl implements SaveApodInHomeService {
  @override
  Future<void> call(ApodEntity apod) async {
    try {
      Image downloadImage = Image.network(
        apod.url,
        fit: BoxFit.cover,
        height: 800,
        width: 800,
      );

      final ImageStream stream =
          downloadImage.image.resolve(const ImageConfiguration());

      final Completer<void> completer = Completer<void>();
      stream.addListener(ImageStreamListener((image, synchronousCall) {
        completer.complete();
      }, onError: (error, stackTrace) {
        completer.completeError(error);
      }));

      await completer.future;

      final result = await HomeWidget.renderFlutterWidget(
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 800,
            maxWidth: 800,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: downloadImage,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        '${apod.title} - ${AppPipes.formatDate(apod.date, format: 'dd/MM/yyyy')}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        key: 'apodImageRendered',
        logicalSize: const Size(800, 800),
      );

      debugPrint(result);

      await HomeWidget.updateWidget(
        androidName: 'ApodWidget',
      );
    } catch (e) {
      log('Erro ao salvar dados do HomeWidget: $e');
    }
  }
}
