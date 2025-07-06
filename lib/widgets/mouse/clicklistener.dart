import 'package:flutter/widgets.dart';

/// A widget that listens just for normal clicks (taps) with quick response time,
/// while properly ignoring drags.
///
/// This is to replace the default [GestureDetector] which has a huge delay
class ClickListener extends StatefulWidget {
  final Function(PointerUpEvent) onClick;
  final Widget child;

  const ClickListener({super.key, required this.onClick, required this.child});

  @override
  State<ClickListener> createState() => _ClickListenerState();
}

class _ClickListenerState extends State<ClickListener> {
  Offset? _dragStart;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _dragStart = event.localPosition;
      },
      onPointerUp: (event) {
        if (_dragStart == null ||
            (event.localPosition - _dragStart!).distance < 5) {
          widget.onClick(event);
        }
      },
      child: widget.child,
    );
  }
}
