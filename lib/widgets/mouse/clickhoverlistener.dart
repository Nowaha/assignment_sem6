import 'package:assignment_sem6/widgets/mouse/clicklistener.dart';
import 'package:flutter/widgets.dart';

/// A wrapper for [ClickListener] that also listens for mouse hover events.
/// See [ClickListener] for more details as to why this is necessary.
class ClickHoverListener extends StatelessWidget {
  final Widget child;
  final VoidCallback? onClick;
  final VoidCallback? mouseEnter;
  final VoidCallback? mouseLeave;

  const ClickHoverListener({
    super.key,
    required this.child,
    this.onClick,
    this.mouseEnter,
    this.mouseLeave,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => mouseEnter?.call(),
      onExit: (_) => mouseLeave?.call(),
      child: ClickListener(onClick: onClick ?? () {}, child: child),
    );
  }
}
