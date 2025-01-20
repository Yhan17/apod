import '../../../../core/entities/apod_entity.dart';
import '../../domain/home_domain.dart';
import '../datasources/saved_apod_datasource.dart';

class IsSavedApodRepositoryImpl implements IsSavedApodRepository {
  final SavedApodDatasource datasource;

  IsSavedApodRepositoryImpl(this.datasource);
  @override
  Future<bool> isApodSaved(ApodEntity? apod) {
    return datasource.isApodSaved(apod);
  }
}
