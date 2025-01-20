import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/http/failures/http_failure.dart';
import 'package:apod/app/modules/home/data/datasources/apod_datasource.dart';
import 'package:apod/app/modules/home/data/repositories/apod_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockApodDatasource extends Mock implements ApodDatasource {}

void main() {
  late MockApodDatasource mockDatasource;
  late ApodRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockApodDatasource();
    repository = ApodRepositoryImpl(mockDatasource);
  });

  group('ApodRepositoryImpl', () {
    final mockDate = DateTime(2025);
    final mockApod = ApodEntity(
      date: mockDate,
      explanation: 'Mock explanation',
      mediaType: MediaType.image,
      serviceVersion: '1.0',
      title: 'Mock title',
      url: 'https://mockurl.com',
      copyright: 'Mock copyright',
      hdUrl: 'https://mockhdurl.com',
    );

    group('getApod', () {
      test('should return ApodEntity when datasource call is successful',
          () async {
        when(() => mockDatasource.getApod(date: any(named: 'date')))
            .thenAnswer((_) async => Success(mockApod));

        final result = await repository.getApod(date: mockDate);

        expect(result.isSuccess(), isTrue);
        expect(result.tryGetSuccess(), equals(mockApod));
        verify(() => mockDatasource.getApod(date: mockDate)).called(1);
      });

      test('should return HttpFailure when datasource call fails', () async {
        when(() => mockDatasource.getApod(date: any(named: 'date')))
            .thenAnswer((_) async => Error(HttpFailure.badRequest));

        final result = await repository.getApod(date: mockDate);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), equals(HttpFailure.badRequest));
        verify(() => mockDatasource.getApod(date: mockDate)).called(1);
      });

      test('should return HttpFailure.unknown when an exception is thrown',
          () async {
        when(() => mockDatasource.getApod(date: any(named: 'date')))
            .thenThrow(Exception('Unexpected error'));

        final result = await repository.getApod(date: mockDate);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), equals(HttpFailure.unknown));
        verify(() => mockDatasource.getApod(date: mockDate)).called(1);
      });
    });

    group('saveApod', () {
      test('should return Unit when datasource call is successful', () async {
        when(() => mockDatasource.saveApod(any()))
            .thenAnswer((_) async => Success(unit));

        final result = await repository.saveApod(mockApod);

        expect(result.isSuccess(), isTrue);
        expect(result.tryGetSuccess(), equals(unit));
        verify(() => mockDatasource.saveApod(mockApod)).called(1);
      });

      test('should return Exception when datasource call fails', () async {
        final exception = Exception('Save failed');
        when(() => mockDatasource.saveApod(any()))
            .thenAnswer((_) async => Error(exception));

        final result = await repository.saveApod(mockApod);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), equals(exception));
        verify(() => mockDatasource.saveApod(mockApod)).called(1);
      });

      test('should return Exception when an exception is thrown', () async {
        final exception = Exception('Unexpected error');
        when(() => mockDatasource.saveApod(any())).thenThrow(exception);

        final result = await repository.saveApod(mockApod);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), equals(exception));
        verify(() => mockDatasource.saveApod(mockApod)).called(1);
      });
    });
  });
}
