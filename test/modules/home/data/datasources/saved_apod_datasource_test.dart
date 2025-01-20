import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/utils/app_pipes.dart';
import 'package:apod/app/modules/home/data/datasources/saved_apod_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<ApodEntity> {}

void main() {
  late MockHiveInterface mockHive;
  late MockHiveBox mockBox;
  late SavedApodDatasourceImpl datasource;

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockHiveBox();
    datasource = SavedApodDatasourceImpl(mockHive);

    when(() => mockHive.openBox<ApodEntity>(any()))
        .thenAnswer((_) async => mockBox);
    when(() => mockBox.close()).thenAnswer((_) async {});
  });

  group('SavedApodDatasourceImpl', () {
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

    test('should return true when ApodEntity is saved', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(true);

      final result = await datasource.isApodSaved(mockApod);

      expect(result, isTrue);
      verify(() => mockBox.containsKey(key)).called(1);
      verify(() => mockBox.close()).called(1);
    });

    test('should return false when ApodEntity is not saved', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(false);

      final result = await datasource.isApodSaved(mockApod);

      expect(result, isFalse);
      verify(() => mockBox.containsKey(key)).called(1);
      verify(() => mockBox.close()).called(1);
    });

    test('should return false when ApodEntity is null', () async {
      final result = await datasource.isApodSaved(null);

      expect(result, isFalse);
      verifyNever(() => mockBox.containsKey(any()));
      verifyNever(() => mockBox.close());
    });

    test('should return false when an exception occurs', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key))
          .thenThrow(Exception('Unexpected Error'));

      final result = await datasource.isApodSaved(mockApod);

      expect(result, isFalse);
      verify(() => mockBox.containsKey(key)).called(1);
      verify(() => mockBox.close()).called(1);
    });
  });
}
