import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class SaveApodUsecase {
  final ApodRepository _repository;

  SaveApodUsecase(this._repository);

  Future<Result<Unit, Exception>> call(ApodEntity? apod) {
    return _repository.saveApod(apod);
  }
}
