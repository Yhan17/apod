import 'package:multiple_result/multiple_result.dart';
import 'package:hive/hive.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/utils/app_pipes.dart';

abstract class RemoveApodDatasource {
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod);
}

class RemoveApodDatasourceImpl implements RemoveApodDatasource {
  final String _boxName = 'apods';

  const RemoveApodDatasourceImpl();

  @override
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod) async {
    final box = await Hive.openBox<ApodEntity>(_boxName);
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
