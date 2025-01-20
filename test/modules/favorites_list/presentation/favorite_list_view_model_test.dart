import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_list/domain/favorite_list_domain.dart';
import 'package:apod/app/modules/favorites_list/presentation/favorites_list_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockGetFavoriteListUsecase extends Mock
    implements GetFavoriteListUsecase {}

void main() {
  late MockGetFavoriteListUsecase mockUsecase;
  late FavoriteListViewModel viewModel;

  setUp(() {
    mockUsecase = MockGetFavoriteListUsecase();
    viewModel = FavoriteListViewModel(mockUsecase);
  });

  group('FavoriteListViewModel', () {
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

    test('should update favorites when usecase returns success', () async {
      when(() => mockUsecase()).thenAnswer((_) async => Success(mockApodList));

      await viewModel.fetchStoredApods();

      expect(viewModel.favorites, equals(mockApodList));
      expect(viewModel.errorMessage, isNull);
    });

    test('should update errorMessage when usecase returns error', () async {
      final exception = Exception('Failed to fetch favorites');
      when(() => mockUsecase()).thenAnswer((_) async => Error(exception));

      await viewModel.fetchStoredApods();

      expect(viewModel.favorites, isEmpty);
      expect(viewModel.errorMessage, contains('Failed to fetch favorites'));
    });
  });
}
