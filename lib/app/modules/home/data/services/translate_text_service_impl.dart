import 'dart:developer';

import 'package:multiple_result/multiple_result.dart';
import 'package:translator/translator.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../domain/services/translate_text_service.dart';

class TranslateTextServiceImpl implements TranslateTextService {
  final GoogleTranslator _translator;
  final String targetLanguage;

  TranslateTextServiceImpl(
    this._translator, {
    required this.targetLanguage,
  });

  @override
  Future<Result<ApodEntity, Unit>> translateApodEntity(
      ApodEntity entity) async {
    try {
      final translatedTitle = await _translator.translate(
        entity.title,
        to: targetLanguage,
      );
      final translatedDescription = await _translator.translate(
        entity.explanation,
        to: targetLanguage,
      );

      return Success(
        entity.copyWith(
          title: translatedTitle.text,
          explanation: translatedDescription.text,
        ),
      );
    } catch (e) {
      log('Erro ao traduzir o APOD: $e');
      return Error(unit);
    }
  }
}
