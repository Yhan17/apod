enum MediaType {
  image,
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

class ApodEntity {
  final String? copyright;
  final DateTime date;
  final String explanation;
  final String? hdUrl;
  final MediaType mediaType;
  final String serviceVersion;
  final String title;
  final String url;

  const ApodEntity({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdUrl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  factory ApodEntity.fromJson(Map<String, dynamic> json) {
    return ApodEntity(
      copyright: json['copyright'],
      date: DateTime.parse(json['date']),
      explanation: json['explanation'],
      hdUrl: json['hdurl'],
      mediaType: MediaType.fromString(json['media_type']),
      serviceVersion: json['service_version'],
      title: json['title'],
      url: json['url'],
    );
  }
}
