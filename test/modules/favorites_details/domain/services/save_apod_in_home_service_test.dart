import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_details/domain/favorite_details_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSaveApodInHomeService extends Mock implements SaveApodInHomeService {}

void main() {
  late MockSaveApodInHomeService mockService;

  setUp(() {
    mockService = MockSaveApodInHomeService();
  });

  group('SaveApodInHomeService', () {
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

    test('should call the service with the given ApodEntity', () async {
      when(() => mockService.call(mockApod)).thenAnswer((_) async {});

      await mockService.call(mockApod);

      verify(() => mockService.call(mockApod)).called(1);
    });

    test('should throw an exception when the service fails', () async {
      final exception = Exception('Service failed');
      when(() => mockService.call(mockApod)).thenThrow(exception);

      expect(() => mockService.call(mockApod), throwsA(isA<Exception>()));
      verify(() => mockService.call(mockApod)).called(1);
    });
  });
}
