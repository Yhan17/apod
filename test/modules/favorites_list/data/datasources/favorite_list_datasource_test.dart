import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_list/data/favorite_list_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<ApodEntity> {}

void main() {
  late MockHiveInterface mockHive;
  late MockHiveBox mockBox;
  late FavoriteListDatasourceImpl datasource;

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockHiveBox();
    datasource = FavoriteListDatasourceImpl(mockHive);
    when(() => mockHive.openBox<ApodEntity>(any()))
        .thenAnswer((_) async => mockBox);
    when(() => mockBox.close()).thenAnswer((_) async {});
  });

  group('FavoriteListDatasourceImpl', () {
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
        date: DateTime(2025),
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
      when(() => mockBox.values).thenReturn(mockApodList);

      final result = await datasource.fetchStoredApods();

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(mockApodList));
      verify(() => mockHive.openBox<ApodEntity>('apods')).called(1);
      verify(() => mockBox.close()).called(1);
    });

    test('should return an exception on failure', () async {
      when(() => mockBox.values).thenThrow(Exception('Unexpected error'));

      final result = await datasource.fetchStoredApods();

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), isA<Exception>());
      verify(() => mockHive.openBox<ApodEntity>('apods')).called(1);
      verify(() => mockBox.close()).called(1);
    });
  });
}
