import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'apod_entity.freezed.dart';
part 'apod_entity.g.dart';

@HiveType(typeId: 0)
enum MediaType {
  @HiveField(0)
  image,
  @HiveField(1)
  video;

  factory MediaType.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'image':
        return MediaType.image;
      case 'video':
        return MediaType.video;
      default:
        throw ArgumentError('Invalid media type: $value');
    }
  }
}

@freezed
class ApodEntity with _$ApodEntity {
  @HiveType(typeId: 1)
  const factory ApodEntity({
    @HiveField(0) required String? copyright,
    @HiveField(1) required DateTime date,
    @HiveField(2) required String explanation,
    @HiveField(3) required String? hdUrl,
    @HiveField(4) required MediaType mediaType,
    @HiveField(5) required String serviceVersion,
    @HiveField(6) required String title,
    @HiveField(7) required String url,
  }) = _ApodEntity;

  factory ApodEntity.fromJson(Map<String, dynamic> json) =>
      _$ApodEntityFromJson(json);
}
