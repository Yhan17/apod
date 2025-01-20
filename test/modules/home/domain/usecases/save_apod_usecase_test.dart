import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockApodRepository extends Mock implements ApodRepository {}

void main() {
  late MockApodRepository mockRepository;
  late SaveApodUsecase saveApodUsecase;

  setUp(() {
    mockRepository = MockApodRepository();
    saveApodUsecase = SaveApodUsecase(mockRepository);
  });

  group('SaveApodUsecase', () {
    final mockApod = ApodEntity(
      date: DateTime(2025),
      explanation: 'Mock explanation',
      mediaType: MediaType.image,
      serviceVersion: '1.0',
      title: 'Mock title',
      url: 'https://mockurl.com',
      copyright: 'Mock copyright',
      hdUrl: 'https://mockhdurl.com',
    );
    test('should return Unit when repository successfully saves Apod',
        () async {
      when(() => mockRepository.saveApod(mockApod))
          .thenAnswer((_) async => Success(unit));

      final result = await saveApodUsecase.call(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockRepository.saveApod(mockApod)).called(1);
    });

    test('should return Exception when repository fails to save Apod',
        () async {
      final exception = Exception('Failed to save Apod');
      when(() => mockRepository.saveApod(mockApod))
          .thenAnswer((_) async => Error(exception));

      final result = await saveApodUsecase.call(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockRepository.saveApod(mockApod)).called(1);
    });

    test('should handle null Apod gracefully', () async {
      when(() => mockRepository.saveApod(null))
          .thenAnswer((_) async => Error(Exception('Null Apod not allowed')));

      final result = await saveApodUsecase.call(null);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), isA<Exception>());
      verify(() => mockRepository.saveApod(null)).called(1);
    });
  });
}
