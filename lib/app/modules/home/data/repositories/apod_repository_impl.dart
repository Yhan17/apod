import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../domain/home_domain.dart';
import '../datasources/apod_datasource.dart';

class ApodRepositoryImpl implements ApodRepository {
  final ApodDatasource _datasource;

  ApodRepositoryImpl(this._datasource);

  @override
  Future<Result<ApodEntity, HttpFailure>> getApod({DateTime? date}) async {
    try {
      final result = await _datasource.getApod(date: date);

      return result;
    } catch (_) {
      return Error(HttpFailure.unknown);
    }
  }

  @override
  Future<Result<Unit, Exception>> saveApod(ApodEntity? apod) async {
    try {
      final result = await _datasource.saveApod(apod);

      return result;
    } on Exception catch (e) {
      return Error(e);
    }
  }
}
