import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';

abstract class RemoveApodFromHomeRepository {
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod);
}
