import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';

abstract class RemoveApodRepository {
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod);
}
