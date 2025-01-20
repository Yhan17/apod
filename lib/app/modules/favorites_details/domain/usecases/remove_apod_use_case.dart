import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../repositories/remove_apod_repository.dart';

class RemoveApodUseCase {
  final RemoveApodRepository repository;

  RemoveApodUseCase(this.repository);

  Future<Result<Unit, Exception>> call(ApodEntity apod) async {
    return repository.removeApod(apod);
  }
}
