import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineTooltip extends StatelessWidget {
  final TimelineItem item;
  final Color textColor;
  final bool preferBelow;
  final Widget child;

  const TimelineTooltip({
    super.key,
    required this.item,
    required this.textColor,
    this.preferBelow = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = DateUtil.formatTime(item.startTimestamp, true);
    final end = DateUtil.formatTime(item.endTimestamp, true);

    return Tooltip(
      preferBelow: preferBelow,
      message: "${item.name}\n($start - $end)\nTags: ${item.tags.join(", ")}",
      decoration: BoxDecoration(
        color: item.color.withAlpha(200),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: TextStyle(color: textColor),
      child: Container(
        color: item.color,
        alignment: Alignment.centerLeft,
        child: Padding(padding: const EdgeInsets.all(8.0), child: child),
      ),
    );
  }
}
