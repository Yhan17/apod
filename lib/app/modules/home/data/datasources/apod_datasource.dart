import 'dart:convert';

import 'package:multiple_result/multiple_result.dart';

import '../../../../core/entities/apod_entity.dart';
import '../../../../core/http/failures/http_failure.dart';
import '../../../../core/http/nasa_apod_http_client.dart';
import '../../../../core/utils/app_pipes.dart';

abstract class ApodDatasource {
  Future<Result<ApodEntity, HttpFailure>> getApod({DateTime? date});
}

class ApodDatasourceImpl implements ApodDatasource {
  final NasaApodClient _client;

  ApodDatasourceImpl(this._client);

  @override
  Future<Result<ApodEntity, HttpFailure>> getApod({DateTime? date}) async {
    try {
      final uri = Uri(path: '/planetary/apod', queryParameters: {
        if (date != null) 'date': AppPipes.formatDate(date),
      });

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final apodEntity = ApodEntity.fromJson(data);
        return Success(apodEntity);
      } else {
        return Error(AppPipes.handleHttpError(response.statusCode));
      }
    } catch (_) {
      return Error(HttpFailure.unknown);
    }
  }
}
