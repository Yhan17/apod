import '../../../../core/entities/apod_entity.dart';
import '../repositories/saved_apod_repository.dart';

class IsPodSavedUsecase {
  final SavedApodRepository repository;

  IsPodSavedUsecase(this.repository);

  Future<bool> call(ApodEntity apod) async {
    return repository.isApodSaved(apod);
  }
}
