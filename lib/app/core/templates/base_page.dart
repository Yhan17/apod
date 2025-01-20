// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

import 'notifiers/loading_notifier.dart';

abstract class BasePage<VM extends ChangeNotifier> extends StatefulWidget {
  final VM viewModel;

  final bool keepAlive;

  const BasePage({
    super.key,
    required this.viewModel,
    this.keepAlive = true,
  });

  Widget buildPage(BuildContext context, VM viewModel);

  void onPageLoad(BuildContext context, VM viewModel) {}

  void onPageDisappear(BuildContext context, VM viewModel) {}

  void onPageAppear(BuildContext context, VM viewModel) {}

  @override
  _BasePageState<VM> createState() => _BasePageState<VM>();
}

class _BasePageState<VM extends ChangeNotifier> extends State<BasePage<VM>>
    with AutomaticKeepAliveClientMixin {
  bool _isPageLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isPageLoaded) {
        widget.onPageLoad(context, widget.viewModel);
        _isPageLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadingNotifier(
      notifier: widget.viewModel,
      child: FocusDetector(
        onFocusGained: () {
          widget.onPageAppear(context, widget.viewModel);
        },
        onFocusLost: () {
          widget.onPageDisappear(context, widget.viewModel);
        },
        child: AnimatedBuilder(
          animation: widget.viewModel,
          builder: (context, _) {
            return widget.buildPage(context, widget.viewModel);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
