import 'package:multiple_result/multiple_result.dart';

import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class GetApodUsecase {
  final ApodRepository _repository;

  GetApodUsecase(this._repository);

  Future<Result<ApodEntity, HttpFailure>> call({DateTime? date}) {
    return _repository.getApod(date: date);
  }
}
