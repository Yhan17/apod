import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/utils/app_pipes.dart';
import 'package:apod/app/modules/favorites_details/data/favorite_details_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<ApodEntity> {}

void main() {
  late MockHiveInterface mockHive;
  late MockHiveBox mockBox;
  late RemoveApodDatasourceImpl datasource;

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockHiveBox();
    datasource = RemoveApodDatasourceImpl(mockHive);

    when(() => mockHive.openBox<ApodEntity>(any()))
        .thenAnswer((_) async => mockBox);
    when(() => mockBox.close()).thenAnswer((_) async {});
  });

  group('RemoveApodDatasourceImpl', () {
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

    test('should return Success(Unit) when APOD is successfully removed',
        () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(true);
      when(() => mockBox.delete(key)).thenAnswer((_) async {});

      final result = await datasource.removeApod(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockBox.delete(key)).called(1);
      verify(() => mockBox.close()).called(1);
    });

    test('should return Error(Exception) when APOD is not found', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(false);

      final result = await datasource.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), isA<Exception>());
      verifyNever(() => mockBox.delete(any()));
      verify(() => mockBox.close()).called(1);
    });

    test('should return Error(Exception) when an error occurs during removal',
        () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(true);
      when(() => mockBox.delete(key)).thenThrow(Exception('Deletion failed'));

      final result = await datasource.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), isA<Exception>());
      verify(() => mockBox.delete(key)).called(1);
      verify(() => mockBox.close()).called(1);
    });
  });
}
