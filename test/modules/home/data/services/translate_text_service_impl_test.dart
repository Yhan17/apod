import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/data/home_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:translator/translator.dart';

class MockGoogleTranslator extends Mock implements GoogleTranslator {}

class MockTranslation extends Mock implements Translation {}

void main() {
  late MockGoogleTranslator mockTranslator;
  late TranslateTextServiceImpl translateTextService;
  const targetLanguage = 'pt';

  setUp(() {
    mockTranslator = MockGoogleTranslator();
    translateTextService = TranslateTextServiceImpl(
      mockTranslator,
      targetLanguage: targetLanguage,
    );
  });

  group('TranslateTextServiceImpl', () {
    final apodEntity = ApodEntity(
      date: DateTime(2025),
      explanation: 'Explanation in English',
      mediaType: MediaType.image,
      serviceVersion: '1.0',
      title: 'Title in English',
      url: 'https://mockurl.com',
      copyright: 'Copyright',
      hdUrl: 'https://mockhdurl.com',
    );

    final mockTitleTranslation = MockTranslation();
    final mockExplanationTranslation = MockTranslation();

    setUp(() {
      when(() => mockTitleTranslation.text).thenReturn('Título em Português');
      when(() => mockExplanationTranslation.text)
          .thenReturn('Explicação em Português');
    });

    test('should return translated ApodEntity on success', () async {
      when(() => mockTranslator.translate(apodEntity.title, to: targetLanguage))
          .thenAnswer((_) async => mockTitleTranslation);
      when(() => mockTranslator.translate(apodEntity.explanation,
              to: targetLanguage))
          .thenAnswer((_) async => mockExplanationTranslation);

      final result = await translateTextService.translateApodEntity(apodEntity);

      expect(result, isA<Success<ApodEntity, Unit>>());
      final successEntity = (result as Success).success;
      expect(successEntity.title, equals('Título em Português'));
      expect(successEntity.explanation, equals('Explicação em Português'));
    });
  });
}
