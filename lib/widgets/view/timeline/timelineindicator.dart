import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelineIndicator extends StatelessWidget {
  final bool isLeft;
  final double timelineHeight;
  final VoidCallback? expand;

  const TimelineIndicator({
    super.key,
    required this.timelineHeight,
    required this.isLeft,
    this.expand,
  });

  @override
  Widget build(BuildContext context) {
    final timelineState = context.watch<TimelineState>();
    bool isOnEdge =
        isLeft
            ? timelineState.startTimestamp ==
                timelineState.visibleStartTimestamp
            : timelineState.endTimestamp == timelineState.visibleEndTimestamp;

    IconData iconData = isLeft ? Icons.arrow_left : Icons.arrow_right;
    final Color? backgroundColor;
    final Color? iconColor;

    if (isOnEdge) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      iconColor = Theme.of(context).colorScheme.onPrimaryContainer;
    } else {
      backgroundColor = Theme.of(
        context,
      ).colorScheme.secondaryContainer.withAlpha(100);
      iconColor = Theme.of(context).colorScheme.onSecondaryContainer;
    }

    return Positioned(
      left: isLeft ? 8 : null,
      right: isLeft ? null : 8,
      top: timelineHeight / 2 - 22,
      child: Material(
        elevation: 4,
        color: backgroundColor,
        borderRadius: isOnEdge ? BorderRadius.circular(28) : null,
        shape:
            !isOnEdge
                ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                    width: 2,
                  ),
                )
                : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isOnEdge ? expand : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Tooltip(
              message:
                  isOnEdge
                      ? "Expand to ${isLeft ? "left" : "right"} by ${DateUtil.formatIntervalShort(TimelineUtil.preferredExpansion(timelineState.visibleTimeScale))}"
                      : "",
              child: Icon(iconData, size: 28, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
