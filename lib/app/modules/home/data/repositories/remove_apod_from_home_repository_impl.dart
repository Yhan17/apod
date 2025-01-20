import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../domain/home_domain.dart';
import '../datasources/remove_apod_frrom_home_datasource.dart';

class RemoveApodFromHomeRepositoryImpl implements RemoveApodFromHomeRepository {
  final RemoveApodFromHomeDatasource _datasource;

  RemoveApodFromHomeRepositoryImpl(this._datasource);

  @override
  Future<Result<Unit, Exception>> removeApod(ApodEntity apod) {
    return _datasource.removeApod(apod);
  }
}
