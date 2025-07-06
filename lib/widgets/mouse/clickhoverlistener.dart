import 'package:assignment_sem6/widgets/mouse/clicklistener.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A wrapper for [ClickListener] that also listens for mouse hover events.
/// See [ClickListener] for more details as to why this is necessary.
class ClickHoverListener extends StatelessWidget {
  final HitTestBehavior hitTestBehavior;
  final MouseCursor? cursor;
  final Function(PointerUpEvent)? onClick;
  final VoidCallback? mouseEnter;
  final VoidCallback? mouseLeave;
  final Function(PointerHoverEvent)? onHover;
  final Widget child;

  const ClickHoverListener({
    super.key,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.onClick,
    this.mouseEnter,
    this.mouseLeave,
    this.onHover,
    this.cursor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: hitTestBehavior,
      onEnter: (_) => mouseEnter?.call(),
      onExit: (_) => mouseLeave?.call(),
      onHover: onHover,
      cursor: cursor ?? SystemMouseCursors.click,
      child: ClickListener(
        hitTestBehavior: hitTestBehavior,
        onClick: onClick ?? (_) {},
        child: child,
      ),
    );
  }
}
