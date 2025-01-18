part of 'routes.dart';

class PageRoute<ArgType> {
  final String path;

  const PageRoute(this.path);

  Future<T?> push<T extends Object?>(
    BuildContext context, {
    ArgType? arguments,
  }) {
    return Navigator.of(context).pushNamed(
      path,
      arguments: arguments,
    );
  }

  Future<T?> pushReplacement<T extends Object?>(
    BuildContext context, {
    ArgType? arguments,
  }) {
    return Navigator.of(context).pushReplacementNamed(
      path,
      arguments: arguments,
    );
  }

  void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}

class NoArgs {
  const NoArgs();
}

const noArgs = NoArgs();
