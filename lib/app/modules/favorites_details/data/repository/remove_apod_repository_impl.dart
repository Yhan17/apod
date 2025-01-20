import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../domain/repositories/remove_apod_repository.dart';
import '../datasource/remove_apod_datasource.dart';

class RemoveApodRepositoryImpl implements RemoveApodRepository {
  final RemoveApodDatasource _datasource;

  RemoveApodRepositoryImpl(this._datasource);

  @override
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod) {
    return _datasource.removeApod(apod);
  }
}
