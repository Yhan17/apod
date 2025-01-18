import 'package:flutter/material.dart';

mixin LoadingMixin on ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> executeWithLoading(Future<void> Function() action) async {
    setLoading(true);
    try {
      await action();
    } finally {
      setLoading(false);
    }
  }
}
