import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/domain/repositories/is_saved_apod_repository.dart';
import 'package:apod/app/modules/home/domain/usecases/is_pod_saved_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIsSavedApodRepository extends Mock implements IsSavedApodRepository {}

void main() {
  late MockIsSavedApodRepository mockRepository;
  late IsPodSavedUsecase isPodSavedUsecase;

  setUp(() {
    mockRepository = MockIsSavedApodRepository();
    isPodSavedUsecase = IsPodSavedUsecase(mockRepository);
  });

  group('IsPodSavedUsecase', () {
    final mockApod = ApodEntity(
      date: DateTime(2025),
      explanation: 'Mock explanation',
      mediaType: MediaType.image,
      serviceVersion: '1.0',
      title: 'Mock title',
      url: 'https:',
      copyright: 'Mock copyright',
      hdUrl: 'https:',
    );

    test('should return true when repository confirms Apod is saved', () async {
      when(() => mockRepository.isApodSaved(mockApod))
          .thenAnswer((_) async => true);

      final result = await isPodSavedUsecase.call(mockApod);

      expect(result, isTrue);
      verify(() => mockRepository.isApodSaved(mockApod)).called(1);
    });

    test('should return false when repository confirms Apod is not saved',
        () async {
      when(() => mockRepository.isApodSaved(mockApod))
          .thenAnswer((_) async => false);

      final result = await isPodSavedUsecase.call(mockApod);

      expect(result, isFalse);
      verify(() => mockRepository.isApodSaved(mockApod)).called(1);
    });

    test('should handle null Apod gracefully', () async {
      when(() => mockRepository.isApodSaved(null))
          .thenAnswer((_) async => false);

      final result = await isPodSavedUsecase.call(null);

      expect(result, isFalse);
      verify(() => mockRepository.isApodSaved(null)).called(1);
    });
  });
}
