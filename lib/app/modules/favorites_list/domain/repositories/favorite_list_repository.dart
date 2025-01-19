import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';

abstract class FavoriteListRepository {
  Future<Result<List<ApodEntity>, Exception>> fetchStoredApods();
}
