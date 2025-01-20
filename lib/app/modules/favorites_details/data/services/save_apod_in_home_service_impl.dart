import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/utils/app_pipes.dart';
import '../../domain/favorite_details_domain.dart';

class SaveApodInHomeServiceImpl implements SaveApodInHomeService {
  final HomeWidgetHelper _helper;
  final ImageLoader _imageLoader;

  SaveApodInHomeServiceImpl({
    HomeWidgetHelper? helper,
    ImageLoader? imageLoader,
  })  : _helper = helper ?? HomeWidgetHelperImpl(),
        _imageLoader = imageLoader ?? NetworkImageLoader();

  @override
  Future<void> call(ApodEntity apod) async {
    try {
      await _imageLoader.loadImage(apod.url);

      final downloadImage = Image.network(
        apod.url,
        fit: BoxFit.cover,
        height: 800,
        width: 800,
      );

      final result = await _helper.renderWidget(
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 800,
            maxWidth: 800,
          ),
          child: Stack(
            children: [
              Positioned.fill(child: downloadImage),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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

      _helper.printDebug(result);

      await _helper.updateWidget(androidName: 'ApodWidget');
    } catch (e) {
      _helper.printLog('Erro ao salvar dados do HomeWidget: $e');
    }
  }
}

abstract class HomeWidgetHelper {
  Future<dynamic> renderWidget(
    Widget widget, {
    required String key,
    required Size logicalSize,
  });

  Future<void> updateWidget({required String androidName});

  void printDebug(String? message);

  void printLog(String message);
}

class HomeWidgetHelperImpl implements HomeWidgetHelper {
  @override
  Future<dynamic> renderWidget(
    Widget widget, {
    required String key,
    required Size logicalSize,
  }) {
    return HomeWidget.renderFlutterWidget(
      widget,
      key: key,
      logicalSize: logicalSize,
    );
  }

  @override
  Future<void> updateWidget({required String androidName}) {
    return HomeWidget.updateWidget(androidName: androidName);
  }

  @override
  void printDebug(String? message) {
    debugPrint(message);
  }

  @override
  void printLog(String message) {
    log(message);
  }
}

abstract class ImageLoader {
  Future<void> loadImage(String url);
}

class NetworkImageLoader implements ImageLoader {
  @override
  Future<void> loadImage(String url) async {
    final downloadImage = Image.network(
      url,
      fit: BoxFit.cover,
      height: 800,
      width: 800,
    );

    final ImageStream stream =
        downloadImage.image.resolve(const ImageConfiguration());

    final Completer<void> completer = Completer<void>();

    stream.addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          completer.complete();
        },
        onError: (error, stackTrace) {
          completer.completeError(error);
        },
      ),
    );

    await completer.future;
  }
}
