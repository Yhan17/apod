import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../repositories/favorite_list_repository.dart';

class GetFavoriteListUsecase {
  final FavoriteListRepository _repository;

  GetFavoriteListUsecase(this._repository);

  Future<Result<List<ApodEntity>, Exception>> call() {
    return _repository.fetchStoredApods();
  }
}
