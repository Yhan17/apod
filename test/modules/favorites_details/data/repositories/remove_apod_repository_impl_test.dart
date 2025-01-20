import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_details/data/favorite_details_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockRemoveApodDatasource extends Mock implements RemoveApodDatasource {}

void main() {
  late MockRemoveApodDatasource mockDatasource;
  late RemoveApodRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockRemoveApodDatasource();
    repository = RemoveApodRepositoryImpl(mockDatasource);
  });

  group('RemoveApodRepositoryImpl', () {
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
        'should return Success(Unit) when datasource successfully removes the APOD',
        () async {
      when(() => mockDatasource.removeApod(mockApod))
          .thenAnswer((_) async => Success(unit));

      final result = await repository.removeApod(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockDatasource.removeApod(mockApod)).called(1);
    });

    test(
        'should return Error(Exception) when datasource fails to remove the APOD',
        () async {
      final exception = Exception('Failed to remove APOD');
      when(() => mockDatasource.removeApod(mockApod))
          .thenAnswer((_) async => Error(exception));

      final result = await repository.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockDatasource.removeApod(mockApod)).called(1);
    });
  });
}
