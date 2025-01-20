import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/http/failures/http_failure.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockApodRepository extends Mock implements ApodRepository {}

void main() {
  late MockApodRepository mockApodRepository;

  setUp(() {
    mockApodRepository = MockApodRepository();
  });

  group('ApodRepository', () {
    final mockDate = DateTime(2025);
    final mockApod = ApodEntity(
        date: mockDate,
        explanation: '',
        mediaType: MediaType.image,
        serviceVersion: '',
        title: '',
        url: '',
        copyright: '',
        hdUrl: '');

    test('should return ApodEntity when getApod is successful', () async {
      when(() => mockApodRepository.getApod(date: any(named: 'date')))
          .thenAnswer((_) async => Success(mockApod));

      final result = await mockApodRepository.getApod(date: mockDate);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(mockApod));
      verify(() => mockApodRepository.getApod(date: mockDate)).called(1);
    });

    test('should return HttpFailure when getApod fails', () async {
      final failure = HttpFailure.badRequest;
      when(() => mockApodRepository.getApod(date: any(named: 'date')))
          .thenAnswer((_) async => Error(failure));

      final result = await mockApodRepository.getApod(date: mockDate);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(failure));
      verify(() => mockApodRepository.getApod(date: mockDate)).called(1);
    });

    test('should return Unit when saveApod is successful', () async {
      when(() => mockApodRepository.saveApod(any()))
          .thenAnswer((_) async => Success(unit));

      final result = await mockApodRepository.saveApod(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockApodRepository.saveApod(mockApod)).called(1);
    });

    test('should return Exception when saveApod fails', () async {
      final exception = Exception('Save failed');
      when(() => mockApodRepository.saveApod(any()))
          .thenAnswer((_) async => Error(exception));

      final result = await mockApodRepository.saveApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockApodRepository.saveApod(mockApod)).called(1);
    });
  });
}
