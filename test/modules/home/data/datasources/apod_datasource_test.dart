import 'dart:convert';
import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/http/failures/http_failure.dart';
import 'package:apod/app/core/http/nasa_apod_http_client.dart';
import 'package:apod/app/core/utils/app_pipes.dart';
import 'package:apod/app/modules/home/data/datasources/apod_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockNasaApodClient extends Mock implements NasaApodClient {}

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<ApodEntity> {}

void main() {
  late MockNasaApodClient mockClient;
  late MockHiveInterface mockHive;
  late MockHiveBox mockBox;
  late ApodDatasourceImpl datasource;

  setUp(() {
    mockClient = MockNasaApodClient();
    mockHive = MockHiveInterface();
    mockBox = MockHiveBox();
    datasource = ApodDatasourceImpl(mockClient, mockHive);
  });

  group('ApodDatasourceImpl', () {
    final mockDate = DateTime(2025);
    final mockUri = Uri(path: '/planetary/apod', queryParameters: {
      'date': AppPipes.formatDate(mockDate),
    });
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
    final mockJson = jsonEncode(mockApod.toJson());

    group('getApod', () {
      setUp(() {
        when(() => mockHive.isBoxOpen('apods')).thenReturn(true);
        when(() => mockHive.box<ApodEntity>(any())).thenReturn(mockBox);
      });
      
      test('should return ApodEntity when client call is successful', () async {
        when(() => mockClient.get(mockUri))
            .thenAnswer((_) async => http.Response(mockJson, 200));

        final result = await datasource.getApod(date: mockDate);

        expect(result.isSuccess(), isTrue);
        expect(result.tryGetSuccess(), equals(mockApod));
        verify(() => mockClient.get(mockUri)).called(1);
      });

      test('should return HttpFailure when client call fails', () async {
        when(() => mockClient.get(mockUri))
            .thenAnswer((_) async => http.Response('', 400));

        final result = await datasource.getApod(date: mockDate);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), equals(HttpFailure.badRequest));
        verify(() => mockClient.get(mockUri)).called(1);
      });

      test('should return HttpFailure.unknown on exception', () async {
        when(() => mockClient.get(mockUri))
            .thenThrow(Exception('Unexpected Error'));

        final result = await datasource.getApod(date: mockDate);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), equals(HttpFailure.unknown));
        verify(() => mockClient.get(mockUri)).called(1);
      });
    });

    group('saveApod', () {
      setUp(() {
        when(() => mockHive.openBox<ApodEntity>(any()))
            .thenAnswer((_) async => mockBox);
        when(() => mockBox.close()).thenAnswer((_) async {});
        when(() => mockHive.isBoxOpen('apods')).thenReturn(true);
        when(() => mockHive.box<ApodEntity>(any())).thenReturn(mockBox);
      });

      test('should save ApodEntity successfully', () async {
        final key = AppPipes.formatDate(mockApod.date);
        when(() => mockBox.containsKey(key)).thenReturn(false);
        when(() => mockBox.put(key, mockApod)).thenAnswer((_) async {});

        final result = await datasource.saveApod(mockApod);

        expect(result.isSuccess(), isTrue);
        verify(() => mockBox.put(key, mockApod)).called(1);
      });

      test('should return Exception when saving a null ApodEntity', () async {
        final result = await datasource.saveApod(null);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), isA<Exception>());
      });

      test('should return Exception when ApodEntity is already saved',
          () async {
        final key = AppPipes.formatDate(mockApod.date);
        when(() => mockBox.containsKey(key)).thenReturn(true);

        final result = await datasource.saveApod(mockApod);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), isA<Exception>());
      });

      test('should return Exception when saving fails', () async {
        final key = AppPipes.formatDate(mockApod.date);
        when(() => mockBox.containsKey(key)).thenReturn(false);
        when(() => mockBox.put(key, mockApod))
            .thenThrow(Exception('Failed to save'));

        final result = await datasource.saveApod(mockApod);

        expect(result.isError(), isTrue);
        expect(result.tryGetError(), isA<Exception>());
      });
    });
  });
}
