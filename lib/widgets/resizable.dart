import 'package:flutter/material.dart';

class Resizable extends StatefulWidget {
  final double startingWidth;
  final double minWidth;
  final double maxWidth;
  final Function(double) onResize;
  final Widget child;

  const Resizable({
    super.key,
    required this.startingWidth,
    required this.minWidth,
    required this.maxWidth,
    required this.onResize,
    required this.child,
  });

  @override
  State<Resizable> createState() => _ResizableState();
}

class _ResizableState extends State<Resizable> {
  late double _width = widget.startingWidth;
  bool _hovered = false;

  final GlobalKey _childKey = GlobalKey();
  double? _childHeight;

  double? _dragStartGlobalX;
  double? _dragStartWidth;

  void _afterLayout(Duration _) {
    final context = _childKey.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final newHeight = box.size.height;
    if (newHeight != _childHeight) {
      setState(() {
        _childHeight = newHeight;
      });
    }
  }

  @override
  void didUpdateWidget(covariant Resizable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startingWidth != oldWidget.startingWidth) {
      setState(() {
        _width = widget.startingWidth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() => _hovered = false);

        if (_dragStartGlobalX == null || _dragStartWidth == null) return;
        _dragStartGlobalX = null;
        _dragStartWidth = null;
        widget.onResize(_width);
      },
      child: SizedBox(
        width: _dragStartGlobalX == null ? _width + 20 : double.infinity,
        height: _childHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: _width,
              child: KeyedSubtree(key: _childKey, child: widget.child),
            ),
            _hovered
                ? Positioned(
                  left: _width,
                  top: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onHorizontalDragStart: (details) {
                      _dragStartGlobalX = details.globalPosition.dx;
                      _dragStartWidth = _width;
                    },
                    onHorizontalDragUpdate: (details) {
                      if (_dragStartGlobalX == null || _dragStartWidth == null)
                        return;

                      double delta =
                          details.globalPosition.dx - _dragStartGlobalX!;
                      double newWidth = (_dragStartWidth! + delta).clamp(
                        widget.minWidth,
                        widget.maxWidth,
                      );

                      setState(() {
                        _width = newWidth;
                      });
                    },
                    onHorizontalDragEnd: (_) {
                      _dragStartGlobalX = null;
                      _dragStartWidth = null;
                      widget.onResize(_width);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeLeftRight,
                      child: Container(
                        width: 20,
                        height: 80,
                        color: Colors.purple.withAlpha(76),
                        child: const Center(
                          child: Icon(Icons.drag_indicator, size: 16),
                        ),
                      ),
                    ),
                  ),
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
