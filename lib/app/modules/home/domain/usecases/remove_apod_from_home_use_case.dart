import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../repositories/remove_apod_from_home_repository.dart';

class RemoveApodFromHomeUseCase {
  final RemoveApodFromHomeRepository repository;

  RemoveApodFromHomeUseCase(this.repository);

  Future<Result<Unit, Exception>> call(ApodEntity apod) async {
    return repository.removeApod(apod);
  }
}
