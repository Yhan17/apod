import 'package:multiple_result/multiple_result.dart';
import 'package:hive/hive.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/utils/app_pipes.dart';

abstract class RemoveApodFromHomeDatasource {
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod);
}

class RemoveApodFromHomeDatasourceImpl implements RemoveApodFromHomeDatasource {
  final String _boxName = 'apods';
  final HiveInterface _hive;

  const RemoveApodFromHomeDatasourceImpl(this._hive);

  @override
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod) async {
    final box = await _hive.openBox<ApodEntity>(_boxName);
    try {
      final key = AppPipes.formatDate(apod.date);
      if (box.containsKey(key)) {
        await box.delete(key);
        return Success(unit);
      } else {
        return Error(Exception('APOD not found'));
      }
    } catch (e) {
      return Error(Exception('Failed to remove APOD: $e'));
    } finally {
      box.close();
    }
  }
}
