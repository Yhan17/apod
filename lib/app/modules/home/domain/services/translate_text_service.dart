import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';

abstract class TranslateTextService {
  Future<Result<ApodEntity, Unit>> translateApodEntity(
    ApodEntity entity
  );
}
