import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../domain/favorite_list_domain.dart';
import '../datasources/favorite_list_datasource.dart';

class FavoriteListRepositoryImpl implements FavoriteListRepository {
  final FavoriteListDatasource _datasource;

  FavoriteListRepositoryImpl(this._datasource);

  @override
  Future<Result<List<ApodEntity>, Exception>> fetchStoredApods() async {
    try {
      final result = await _datasource.fetchStoredApods();

      return result;
    } on Exception catch (e) {
      return Error(e);
    }
  }
}
