import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_list/data/favorite_list_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockFavoriteListDatasource extends Mock
    implements FavoriteListDatasource {}

void main() {
  late MockFavoriteListDatasource mockDatasource;
  late FavoriteListRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockFavoriteListDatasource();
    repository = FavoriteListRepositoryImpl(mockDatasource);
  });

  group('FavoriteListRepositoryImpl', () {
    final mockApodList = [
      ApodEntity(
        date: DateTime(2025),
        explanation: 'Mock explanation 1',
        mediaType: MediaType.image,
        serviceVersion: '1.0',
        title: 'Mock title 1',
        url: 'https://mockurl1.com',
        copyright: 'Mock copyright 1',
        hdUrl: 'https://mockhdurl1.com',
      ),
      ApodEntity(
        date: DateTime(2024),
        explanation: 'Mock explanation 2',
        mediaType: MediaType.image,
        serviceVersion: '1.0',
        title: 'Mock title 2',
        url: 'https://mockurl2.com',
        copyright: 'Mock copyright 2',
        hdUrl: 'https://mockhdurl2.com',
      ),
    ];

    test('should return a list of ApodEntity on success', () async {
      when(() => mockDatasource.fetchStoredApods())
          .thenAnswer((_) async => Success(mockApodList));

      final result = await repository.fetchStoredApods();

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(mockApodList));
      verify(() => mockDatasource.fetchStoredApods()).called(1);
    });

    test('should return an exception on failure', () async {
      final exception = Exception('Failed to fetch stored APODs');
      when(() => mockDatasource.fetchStoredApods())
          .thenAnswer((_) async => Error(exception));

      final result = await repository.fetchStoredApods();

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockDatasource.fetchStoredApods()).called(1);
    });

    test('should return an exception when datasource throws an exception',
        () async {
      final exception = Exception('Unexpected error');
      when(() => mockDatasource.fetchStoredApods()).thenThrow(exception);

      final result = await repository.fetchStoredApods();

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockDatasource.fetchStoredApods()).called(1);
    });
  });
}
