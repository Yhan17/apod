import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/data/datasources/saved_apod_datasource.dart';
import 'package:apod/app/modules/home/data/repositories/is_saved_apod_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSavedApodDatasource extends Mock implements SavedApodDatasource {}

void main() {
  late MockSavedApodDatasource mockDatasource;
  late IsSavedApodRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockSavedApodDatasource();
    repository = IsSavedApodRepositoryImpl(mockDatasource);
  });

  group('IsSavedApodRepositoryImpl', () {
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

    test('should return true when datasource returns true', () async {
      when(() => mockDatasource.isApodSaved(mockApod))
          .thenAnswer((_) async => true);

      final result = await repository.isApodSaved(mockApod);

      expect(result, isTrue);
      verify(() => mockDatasource.isApodSaved(mockApod)).called(1);
    });

    test('should return false when datasource returns false', () async {
      when(() => mockDatasource.isApodSaved(mockApod))
          .thenAnswer((_) async => false);

      final result = await repository.isApodSaved(mockApod);

      expect(result, isFalse);
      verify(() => mockDatasource.isApodSaved(mockApod)).called(1);
    });

    test('should return false when ApodEntity is null', () async {
      when(() => mockDatasource.isApodSaved(null))
          .thenAnswer((_) async => false);

      final result = await repository.isApodSaved(null);

      expect(result, isFalse);
      verify(() => mockDatasource.isApodSaved(null)).called(1);
    });
  });
}
