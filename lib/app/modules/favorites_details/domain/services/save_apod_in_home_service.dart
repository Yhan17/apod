import '../../../../core/entities/apod_entity.dart';

abstract class SaveApodInHomeService {
  Future<void> call(ApodEntity apod);
}
