import '../../../../core/entities/apod_entity.dart';
import '../repositories/is_saved_apod_repository.dart';

class IsPodSavedUsecase {
  final IsSavedApodRepository repository;

  IsPodSavedUsecase(this.repository);

  Future<bool> call(ApodEntity? apod) async {
    return repository.isApodSaved(apod);
  }
}
