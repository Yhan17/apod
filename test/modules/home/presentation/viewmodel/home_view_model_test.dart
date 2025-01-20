import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/core/http/failures/http_failure.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:apod/app/modules/home/presentation/home_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockGetApodUsecase extends Mock implements GetApodUsecase {}

class MockSaveApodUsecase extends Mock implements SaveApodUsecase {}

class MockIsPodSavedUsecase extends Mock implements IsPodSavedUsecase {}

class MockRemoveApodFromHomeUseCase extends Mock
    implements RemoveApodFromHomeUseCase {}

void main() {
  late MockGetApodUsecase mockGetApodUsecase;
  late MockSaveApodUsecase mockSaveApodUsecase;
  late MockIsPodSavedUsecase mockIsPodSavedUsecase;
  late MockRemoveApodFromHomeUseCase mockRemoveApodFromHomeUseCase;
  late HomeViewModel viewModel;

  setUp(() {
    mockGetApodUsecase = MockGetApodUsecase();
    mockSaveApodUsecase = MockSaveApodUsecase();
    mockIsPodSavedUsecase = MockIsPodSavedUsecase();
    mockRemoveApodFromHomeUseCase = MockRemoveApodFromHomeUseCase();
    viewModel = HomeViewModel(
      mockGetApodUsecase,
      mockSaveApodUsecase,
      mockIsPodSavedUsecase,
      mockRemoveApodFromHomeUseCase,
      null,
    );
  });

  group('fetchApod', () {
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

    test('should fetch APOD and update state on success', () async {
      when(() => mockGetApodUsecase(date: any(named: 'date')))
          .thenAnswer((_) async => Success(mockApod));
      when(() => mockIsPodSavedUsecase(mockApod)).thenAnswer((_) async => true);

      await viewModel.fetchApod(date: DateTime(2025));

      expect(viewModel.apod, equals(mockApod));
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.unfavorite));
    });

    test('should update errorMessage on failure', () async {
      when(() => mockGetApodUsecase(date: any(named: 'date')))
          .thenAnswer((_) async => Error(HttpFailure.badRequest));

      await viewModel.fetchApod(date: DateTime(2025));

      expect(viewModel.apod, isNull);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.empty));
    });
  });

  group('isApodSaved', () {
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

    test('should update buttonLabel to unfavorite if APOD is saved', () async {
      viewModel.apod = mockApod;
      when(() => mockIsPodSavedUsecase(mockApod)).thenAnswer((_) async => true);

      final result = await viewModel.isApodSaved();

      expect(result, isTrue);
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.unfavorite));
    });

    test('should update buttonLabel to favorite if APOD is not saved',
        () async {
      viewModel.apod = mockApod;
      when(() => mockIsPodSavedUsecase(mockApod))
          .thenAnswer((_) async => false);

      final result = await viewModel.isApodSaved();

      expect(result, isFalse);
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.favorite));
    });
  });

  group('saveApodToDatabase', () {
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

    test('should save APOD and update buttonLabel on success', () async {
      viewModel.apod = mockApod;
      when(() => mockSaveApodUsecase(mockApod))
          .thenAnswer((_) async => Success(unit));
      when(() => mockIsPodSavedUsecase(mockApod)).thenAnswer((_) async => true);

      final result = await viewModel.saveApodToDatabase();

      expect(result, equals('APOD salvo com sucesso na base de dados.'));
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.unfavorite));
    });

    test('should return error message on failure', () async {
      viewModel.apod = mockApod;
      when(() => mockSaveApodUsecase(mockApod))
          .thenAnswer((_) async => Error(Exception('Save failed')));

      final result = await viewModel.saveApodToDatabase();

      expect(result, contains('Erro ao salvar APOD na base de dados'));
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.error));
    });
  });

  group('removeApodFromDatabase', () {
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

    test('should remove APOD and update buttonLabel on success', () async {
      viewModel.apod = mockApod;
      when(() => mockRemoveApodFromHomeUseCase(mockApod))
          .thenAnswer((_) async => Success(unit));
      when(() => mockIsPodSavedUsecase(mockApod))
          .thenAnswer((_) async => false);

      final result = await viewModel.removeApodFromDatabase();

      expect(result, equals('APOD removido com sucesso na base de dados.'));
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.favorite));
    });

    test('should return error message on failure', () async {
      viewModel.apod = mockApod;
      when(() => mockRemoveApodFromHomeUseCase(mockApod))
          .thenAnswer((_) async => Error(Exception('Remove failed')));

      final result = await viewModel.removeApodFromDatabase();

      expect(result, contains('Erro ao remover APOD na base de dados'));
      expect(viewModel.buttonLabel, equals(FavoriteButtonLabel.error));
    });
  });
}
