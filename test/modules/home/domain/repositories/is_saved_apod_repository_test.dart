import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIsSavedApodRepository extends Mock implements IsSavedApodRepository {}

void main() {
  late MockIsSavedApodRepository mockRepository;

  setUp(() {
    mockRepository = MockIsSavedApodRepository();
  });

  group('IsSavedApodRepository', () {
    final mockApod = ApodEntity(
        date: DateTime(2025),
        explanation: '',
        mediaType: MediaType.image,
        serviceVersion: '',
        title: '',
        url: '',
        copyright: '',
        hdUrl: '');

    test('should return true when isApodSaved confirms the apod is saved',
        () async {
      when(() => mockRepository.isApodSaved(any()))
          .thenAnswer((_) async => true);

      final result = await mockRepository.isApodSaved(mockApod);

      expect(result, isTrue);
      verify(() => mockRepository.isApodSaved(mockApod)).called(1);
    });

    test('should return false when isApodSaved confirms the apod is not saved',
        () async {
      when(() => mockRepository.isApodSaved(any()))
          .thenAnswer((_) async => false);

      final result = await mockRepository.isApodSaved(mockApod);

      expect(result, isFalse);
      verify(() => mockRepository.isApodSaved(mockApod)).called(1);
    });

    test('should handle null apod gracefully', () async {
      when(() => mockRepository.isApodSaved(null))
          .thenAnswer((_) async => false);

      final result = await mockRepository.isApodSaved(null);

      expect(result, isFalse);
      verify(() => mockRepository.isApodSaved(null)).called(1);
    });
  });
}
