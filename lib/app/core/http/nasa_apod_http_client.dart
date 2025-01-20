import 'package:http/http.dart';

class NasaApodClient extends BaseClient {
  final Client _inner;
  final String baseUrl;
  final String apiKey;

  NasaApodClient({
    required this.baseUrl,
    required this.apiKey,
    Client? inner,
  }) : _inner = inner ?? Client();

  @override
  Future<StreamedResponse> send(covariant Request request) {
    final baseUri = Uri.parse(baseUrl);
    final baseUrlWithResources = request.url.replace(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      queryParameters: {
        ...request.url.queryParameters,
        'api_key': apiKey,
      },
    );

    final newBaseRequest = Request(request.method, baseUrlWithResources);
    newBaseRequest.body = request.body;
    newBaseRequest.headers.addAll({
      ...request.headers,
      'content-type': 'application/json',
      'Accept': 'application/json',
    });

    return _inner.send(newBaseRequest);
  }

  @override
  void close() {
    _inner.close();
  }
}
