import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockRemoveApodFromHomeRepository extends Mock
    implements RemoveApodFromHomeRepository {}

void main() {
  late MockRemoveApodFromHomeRepository mockRepository;
  late RemoveApodFromHomeUseCase removeApodFromHomeUseCase;

  setUp(() {
    mockRepository = MockRemoveApodFromHomeRepository();
    removeApodFromHomeUseCase = RemoveApodFromHomeUseCase(mockRepository);
  });

  group('RemoveApodFromHomeUseCase', () {
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

    test('should return Unit when repository successfully removes Apod',
        () async {
      when(() => mockRepository.removeApod(mockApod))
          .thenAnswer((_) async => Success(unit));

      final result = await removeApodFromHomeUseCase.call(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockRepository.removeApod(mockApod)).called(1);
    });

    test('should return Exception when repository fails to remove Apod',
        () async {
      final exception = Exception('Failed to remove Apod');
      when(() => mockRepository.removeApod(mockApod))
          .thenAnswer((_) async => Error(exception));

      final result = await removeApodFromHomeUseCase.call(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockRepository.removeApod(mockApod)).called(1);
    });
  });
}
