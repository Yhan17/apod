import 'package:hive/hive.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';

abstract class FavoriteListDatasource {
  Future<Result<List<ApodEntity>, Exception>> fetchStoredApods();
}

class FavoriteListDatasourceImpl implements FavoriteListDatasource {
  final String _boxName = 'apods';

  @override
  Future<Result<List<ApodEntity>, Exception>> fetchStoredApods() async {
    try {
      final box = await Hive.openBox<ApodEntity>(_boxName);

      final storedApods = box.values.toList();

      return Success(storedApods);
    } catch (e) {
      return Error(Exception('Erro ao buscar os APODs armazenados: $e'));
    }
  }
}
