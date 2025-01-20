import '../../../../core/entities/apod_entity.dart';

abstract class IsSavedApodRepository {
  Future<bool> isApodSaved(ApodEntity? apod);
}
