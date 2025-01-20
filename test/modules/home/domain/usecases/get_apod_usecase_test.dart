import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/http/failures/http_failure.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockApodRepository extends Mock implements ApodRepository {}

void main() {
  late MockApodRepository mockApodRepository;
  late GetApodUsecase getApodUsecase;

  setUp(() {
    mockApodRepository = MockApodRepository();
    getApodUsecase = GetApodUsecase(mockApodRepository);
  });

  group('GetApodUsecase', () {
    final mockDate = DateTime(2025);
    final mockApod = ApodEntity(
        date: mockDate,
        explanation: 'Mock explanation',
        mediaType: MediaType.image,
        serviceVersion: '1.0',
        title: 'Mock title',
        url: 'https:',
        copyright: 'Mock copyright',
        hdUrl: 'https:');

    test('should return ApodEntity when repository call is successful',
        () async {
      when(() => mockApodRepository.getApod(date: any(named: 'date')))
          .thenAnswer((_) async => Success(mockApod));

      final result = await getApodUsecase.call(date: mockDate);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(mockApod));
      verify(() => mockApodRepository.getApod(date: mockDate)).called(1);
    });

    test('should return HttpFailure when repository call fails', () async {
      final failure = HttpFailure.badRequest;
      when(() => mockApodRepository.getApod(date: any(named: 'date')))
          .thenAnswer((_) async => Error(failure));

      final result = await getApodUsecase.call(date: mockDate);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(failure));
      verify(() => mockApodRepository.getApod(date: mockDate)).called(1);
    });

    test('should call repository with null date if no date is provided',
        () async {
      when(() => mockApodRepository.getApod(date: any(named: 'date')))
          .thenAnswer((_) async => Success(mockApod));

      final result = await getApodUsecase.call();

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(mockApod));
      verify(() => mockApodRepository.getApod()).called(1);
    });
  });
}
