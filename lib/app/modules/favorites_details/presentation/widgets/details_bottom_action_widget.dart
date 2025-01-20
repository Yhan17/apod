import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/context_extension.dart';

class DetailsBottomActionWidget extends StatelessWidget {
  final bool showTransformButton;
  final VoidCallback onTransformWidget;
  final VoidCallback onUnfavorite;

  const DetailsBottomActionWidget({
    super.key,
    required this.showTransformButton,
    required this.onTransformWidget,
    required this.onUnfavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 80,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Skeletonizer(
          enabled: context.isLoading,
          child: Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showTransformButton) ...[
                Expanded(
                  child: InkWell(
                    onTap: onTransformWidget,
                    borderRadius: BorderRadius.circular(8),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          context.loc.convertToWidget,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: InkWell(
                  onTap: onUnfavorite,
                  borderRadius: BorderRadius.circular(8),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        context.loc.unfavorite,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
