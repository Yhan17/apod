import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/home/domain/home_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';

class MockRemoveApodFromHomeRepository extends Mock
    implements RemoveApodFromHomeRepository {}

void main() {
  late MockRemoveApodFromHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockRemoveApodFromHomeRepository();
  });

  group('RemoveApodFromHomeRepository', () {
    final mockApod = ApodEntity(
      date: DateTime(2025),
      explanation: '',
      mediaType: MediaType.image,
      serviceVersion: '',
      title: '',
      url: '',
      copyright: '',
      hdUrl: '',
    );

    test('should return Unit when removeApod is successful', () async {
      when(() => mockRepository.removeApod(mockApod))
          .thenAnswer((_) async => Success(unit));

      final result = await mockRepository.removeApod(mockApod);

      expect(result.isSuccess(), isTrue);
      expect(result.tryGetSuccess(), equals(unit));
      verify(() => mockRepository.removeApod(mockApod)).called(1);
    });

    test('should return Exception when removeApod fails', () async {
      final exception = Exception('Remove failed');
      when(() => mockRepository.removeApod(mockApod))
          .thenAnswer((_) async => Error(exception));

      final result = await mockRepository.removeApod(mockApod);

      expect(result.isError(), isTrue);
      expect(result.tryGetError(), equals(exception));
      verify(() => mockRepository.removeApod(mockApod)).called(1);
    });
  });
}
