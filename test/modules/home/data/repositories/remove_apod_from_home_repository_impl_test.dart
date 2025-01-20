import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/data/datasources/remove_apod_from_home_datasource.dart';
import 'package:apod/app/modules/home/data/repositories/remove_apod_from_home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockRemoveApodFromHomeDatasource extends Mock
    implements RemoveApodFromHomeDatasource {}

void main() {
  late MockRemoveApodFromHomeDatasource mockDatasource;
  late RemoveApodFromHomeRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockRemoveApodFromHomeDatasource();
    repository = RemoveApodFromHomeRepositoryImpl(mockDatasource);
  });

  group('RemoveApodFromHomeRepositoryImpl', () {
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

    test(
        'should return Success(Unit) when datasource successfully removes the ApodEntity',
        () async {
      when(() => mockDatasource.removeApod(mockApod))
          .thenAnswer((_) async => Success(unit));

      final result = await repository.removeApod(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockDatasource.removeApod(mockApod)).called(1);
    });

    test(
        'should return Error(Exception) when datasource fails to remove the ApodEntity',
        () async {
      final exception = Exception('Failed to remove');
      when(() => mockDatasource.removeApod(mockApod))
          .thenAnswer((_) async => Error(exception));

      final result = await repository.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockDatasource.removeApod(mockApod)).called(1);
    });
  });
}
