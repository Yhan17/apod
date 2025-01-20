import '../../../../core/entities/apod_entity.dart';

abstract class SavedApodRepository {
  Future<bool> isApodSaved(ApodEntity? apod);
}
