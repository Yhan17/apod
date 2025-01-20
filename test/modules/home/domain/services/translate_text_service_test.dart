import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockTranslateTextService extends Mock implements TranslateTextService {}

void main() {
  late MockTranslateTextService mockTranslateTextService;

  setUp(() {
    mockTranslateTextService = MockTranslateTextService();
  });

  group('TranslateTextService', () {
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

    final translatedApodEntity = ApodEntity(
      date: apodEntity.date,
      explanation: 'Explicação em Português',
      mediaType: apodEntity.mediaType,
      serviceVersion: apodEntity.serviceVersion,
      title: 'Título em Português',
      url: apodEntity.url,
      copyright: apodEntity.copyright,
      hdUrl: apodEntity.hdUrl,
    );

    test('should return a translated ApodEntity on success', () async {
      when(() => mockTranslateTextService.translateApodEntity(apodEntity))
          .thenAnswer((_) async => Success(translatedApodEntity));

      final result =
          await mockTranslateTextService.translateApodEntity(apodEntity);

      expect(result, isA<Success<ApodEntity, Unit>>());
      expect(result.getOrThrow(), equals(translatedApodEntity));
    });

    test('should return an error on failure', () async {
      when(() => mockTranslateTextService.translateApodEntity(apodEntity))
          .thenAnswer((_) async => const Error(unit));

      final result =
          await mockTranslateTextService.translateApodEntity(apodEntity);

      expect(result, isA<Error<ApodEntity, Unit>>());
    });
  });
}
