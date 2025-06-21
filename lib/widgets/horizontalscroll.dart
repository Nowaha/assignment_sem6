import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HorizontalScroll extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  const HorizontalScroll({
    super.key,
    required this.controller,
    required this.child,
  });

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final newOffset = controller.offset - event.scrollDelta.dy;
      if (newOffset >= 0 && newOffset <= controller.position.maxScrollExtent) {
        controller.jumpTo(newOffset);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerSignal: _onPointerSignal,
    behavior: HitTestBehavior.deferToChild,
    child: child,
  );
}
