import '../http/failures/http_failure.dart';

class AppPipes {
  static String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static HttpFailure handleHttpError(int statusCode) {
    switch (statusCode) {
      case 400:
        return HttpFailure.badRequest;
      case 401:
        return HttpFailure.unauthorized;
      case 403:
        return HttpFailure.forbidden;
      case 404:
        return HttpFailure.notFound;
      case 500:
        return HttpFailure.internalServerError;
      case 503:
        return HttpFailure.serviceUnavailable;
      default:
        return HttpFailure.unknown;
    }
  }
}
