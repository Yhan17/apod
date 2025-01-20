import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_details/domain/favorite_details_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockRemoveApodRepository extends Mock implements RemoveApodRepository {}

void main() {
  late MockRemoveApodRepository mockRepository;
  late RemoveApodUseCase usecase;

  setUp(() {
    mockRepository = MockRemoveApodRepository();
    usecase = RemoveApodUseCase(mockRepository);
  });

  group('RemoveApodUseCase', () {
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

    test('should return Success(Unit) when removal is successful', () async {
      when(() => mockRepository.removeApod(mockApod))
          .thenAnswer((_) async => Success(unit));

      final result = await usecase.call(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockRepository.removeApod(mockApod)).called(1);
    });

    test('should return Error(Exception) when removal fails', () async {
      final exception = Exception('Removal failed');
      when(() => mockRepository.removeApod(mockApod))
          .thenAnswer((_) async => Error(exception));

      final result = await usecase.call(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockRepository.removeApod(mockApod)).called(1);
    });
  });
}
