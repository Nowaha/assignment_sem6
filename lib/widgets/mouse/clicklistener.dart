import 'package:flutter/widgets.dart';

/// A widget that listens just for normal clicks (taps) with quick response time,
/// while properly ignoring drags.
///
/// This is to replace the default [GestureDetector] which has a huge delay
class ClickListener extends StatefulWidget {
  final Widget child;
  final VoidCallback onClick;

  const ClickListener({super.key, required this.child, required this.onClick});

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
          widget.onClick();
        }
      },
      child: widget.child,
    );
  }
}
