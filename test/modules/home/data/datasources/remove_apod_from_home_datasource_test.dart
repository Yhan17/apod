import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/utils/app_pipes.dart';
import 'package:apod/app/modules/home/data/datasources/remove_apod_from_home_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<ApodEntity> {}

void main() {
  late MockHiveInterface mockHive;
  late MockHiveBox mockBox;
  late RemoveApodFromHomeDatasourceImpl datasource;

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockHiveBox();
    datasource = RemoveApodFromHomeDatasourceImpl(mockHive);
  });

  group('RemoveApodFromHomeDatasourceImpl', () {
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

    setUp(() {
      when(() => mockHive.openBox<ApodEntity>(any()))
          .thenAnswer((_) async => mockBox);
      when(() => mockBox.close()).thenAnswer((_) async {});
      when(() => mockHive.isBoxOpen('apods')).thenReturn(true);
      when(() => mockHive.box<ApodEntity>(any())).thenReturn(mockBox);
    });

    test('should remove ApodEntity successfully', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(true);
      when(() => mockBox.delete(key)).thenAnswer((_) async {});

      final result = await datasource.removeApod(mockApod);

      expect(result.isSuccess(), isTrue);
      verify(() => mockBox.delete(key)).called(1);
    });

    test('should return Exception when ApodEntity is not found', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(false);

      final result = await datasource.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), isA<Exception>());
      verifyNever(() => mockBox.delete(any()));
    });

    test('should return Exception when removing fails', () async {
      final key = AppPipes.formatDate(mockApod.date);
      when(() => mockBox.containsKey(key)).thenReturn(true);
      when(() => mockBox.delete(key)).thenThrow(Exception('Failed to delete'));

      final result = await datasource.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), isA<Exception>());
      verify(() => mockBox.delete(key)).called(1);
    });
  });
}
