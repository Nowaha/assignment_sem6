import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class TimelineIndicator extends StatelessWidget {
  final TimelineController controller;
  final double timelineHeight;
  final bool isLeft;
  final VoidCallback? expand;

  const TimelineIndicator({
    super.key,
    required this.controller,
    required this.timelineHeight,
    required this.isLeft,
    this.expand,
  });

  @override
  Widget build(BuildContext context) {
    bool isOnEdge =
        isLeft
            ? controller.startTimestamp == controller.visibleStartTimestamp
            : controller.endTimestamp == controller.visibleEndTimestamp;

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
      top: timelineHeight / 2 - 24,
      child: Material(
        elevation: 4,
        color: backgroundColor,
        borderRadius: isOnEdge ? BorderRadius.circular(32) : null,
        shape:
            !isOnEdge
                ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                    width: 2,
                  ),
                )
                : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: isOnEdge ? expand : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Tooltip(
              message:
                  isOnEdge
                      ? "Expand to ${isLeft ? "left" : "right"} by ${DateUtil.formatInterval(TimelineUtil.preferredExpansion(controller.visibleTimeScale))}"
                      : "",
              child: Icon(iconData, size: 32, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
