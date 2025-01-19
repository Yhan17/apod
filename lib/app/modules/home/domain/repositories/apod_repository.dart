import 'package:multiple_result/multiple_result.dart';

import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/entities/apod_entity.dart';

abstract class ApodRepository {
  Future<Result<ApodEntity, HttpFailure>> getApod({DateTime? date});
  Future<Result<Unit, Exception>> saveApod(ApodEntity? apod);
}
