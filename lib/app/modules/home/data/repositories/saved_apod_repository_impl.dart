import '../../../../core/entities/apod_entity.dart';
import '../../domain/home_domain.dart';
import '../datasources/saved_apod_datasource.dart';

class SavedApodRepositoryImpl implements SavedApodRepository {
  final SavedApodDatasource datasource;

  SavedApodRepositoryImpl(this.datasource);
  @override
  Future<bool> isApodSaved(ApodEntity? apod) {
    return datasource.isApodSaved(apod);
  }
}
