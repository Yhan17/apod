import 'package:hive/hive.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';

abstract class FavoriteListDatasource {
  Future<Result<List<ApodEntity>, Exception>> fetchStoredApods();
}

class FavoriteListDatasourceImpl implements FavoriteListDatasource {
  final String _boxName = 'apods';
  final HiveInterface _hive;

  FavoriteListDatasourceImpl(this._hive);

  @override
  Future<Result<List<ApodEntity>, Exception>> fetchStoredApods() async {
    final box = await _hive.openBox<ApodEntity>(_boxName);
    try {
      final storedApods = box.values.toList();

      return Success(storedApods);
    } catch (e) {
      return Error(Exception('Erro ao buscar os APODs armazenados: $e'));
    } finally {
      box.close();
    }
  }
}
