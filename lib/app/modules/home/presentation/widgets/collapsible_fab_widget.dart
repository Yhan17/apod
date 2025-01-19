import 'package:flutter/material.dart';

class CollapsibleFab extends StatefulWidget {
  final VoidCallback onFavorite;
  final VoidCallback onTransformWidget;

  const CollapsibleFab({
    super.key,
    required this.onFavorite,
    required this.onTransformWidget,
  });

  @override
  State<CollapsibleFab> createState() => _CollapsibleFabState();
}

class _CollapsibleFabState extends State<CollapsibleFab>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Botão secundário: "Transformar em Widget"
        if (_isOpen)
          Positioned(
            bottom: 70,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'transform_widget_fab',
              onPressed: () {
                widget.onTransformWidget();
                _toggle();
              },
              child: const Icon(Icons.widgets),
            ),
          ),
        // Botão secundário: "Favoritar"
        if (_isOpen)
          Positioned(
            bottom: 140,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'favorite_fab',
              onPressed: () {
                widget.onFavorite();
                _toggle();
              },
              child: const Icon(Icons.favorite),
            ),
          ),
        // FAB principal: icone de menu (abre/fecha)
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _controller,
          ),
        ),
      ],
    );
  }
}
