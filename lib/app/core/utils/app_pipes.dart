import '../http/failures/http_failure.dart';
import 'package:intl/intl.dart' as intl;

class AppPipes {
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    final formatter = intl.DateFormat(format);
    return formatter.format(date);
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
