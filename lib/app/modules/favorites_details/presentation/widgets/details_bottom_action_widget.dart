import 'package:flutter/material.dart';

class DetailsBottomActionWidget extends StatelessWidget {
  final VoidCallback onTransformWidget;
  final VoidCallback onUnfavorite;

  const DetailsBottomActionWidget({
    super.key,
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
        child: Row(
          spacing: 4,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    child: const Text(
                      'Transformar em Widget',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
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
                    child: const Text(
                      'Desfavoritar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
