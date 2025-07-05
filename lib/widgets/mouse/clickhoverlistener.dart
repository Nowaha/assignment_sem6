import 'package:assignment_sem6/widgets/mouse/clicklistener.dart';
import 'package:flutter/widgets.dart';

/// A wrapper for [ClickListener] that also listens for mouse hover events.
/// See [ClickListener] for more details as to why this is necessary.
class ClickHoverListener extends StatelessWidget {
  final VoidCallback? onClick;
  final VoidCallback? mouseEnter;
  final VoidCallback? mouseLeave;
  final MouseCursor? cursor;
  final Widget child;

  const ClickHoverListener({
    super.key,
    this.onClick,
    this.mouseEnter,
    this.mouseLeave,
    this.cursor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => mouseEnter?.call(),
      onExit: (_) => mouseLeave?.call(),
      cursor: cursor ?? SystemMouseCursors.click,
      child: ClickListener(onClick: onClick ?? () {}, child: child),
    );
  }
}
