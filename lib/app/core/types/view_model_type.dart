import 'package:flutter/material.dart';

import '../mixins/loading_mixin.dart';

abstract class ViewModel extends ChangeNotifier with LoadingMixin {}
