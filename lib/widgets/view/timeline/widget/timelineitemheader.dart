import 'package:assignment_sem6/extension/color.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/widget/timelineitemtooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimelineItemHeader extends StatelessWidget {
  final TimelineItem item;
  final double width;
  final bool includeSeconds;
  final bool isHanging;

  late final Color textColor;

  TimelineItemHeader({
    super.key,
    required this.item,
    required this.width,
    this.includeSeconds = false,
    this.isHanging = false,
  }) {
    textColor = item.color.getForegroundColor();
  }

  Size _getSize(TextSpan textSpan) {
    final painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.size;
  }

  @override
  Widget build(BuildContext context) {
    final start = DateUtil.formatTime(item.startTimestamp, includeSeconds);
    final end = DateUtil.formatTime(item.endTimestamp, includeSeconds);

    final startSpan = TextSpan(text: start, style: TextStyle(color: textColor));
    final nameSpan = TextSpan(
      text: item.name,
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    );
    final endSpan = TextSpan(text: end, style: TextStyle(color: textColor));
    final startSize = _getSize(startSpan);
    final endSize = _getSize(endSpan);

    final timeWidth = startSize.width + endSize.width + 24;

    final Widget textRow;
    if (width > timeWidth + 48) {
      textRow = Row(
        spacing: 12,
        children: [
          Text.rich(startSpan),
          Expanded(child: Text.rich(nameSpan, overflow: TextOverflow.ellipsis)),
          Text.rich(endSpan),
        ],
      );
    } else if (width > timeWidth + 16) {
      textRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text.rich(startSpan), Text.rich(endSpan)],
      );
    } else if (width > startSize.width + 32) {
      textRow = Text.rich(startSpan, textAlign: TextAlign.start);
    } else {
      textRow = SizedBox(height: _getSize(nameSpan).height);
    }

    return TimelineItemTooltip(
      item: item,
      textColor: textColor,
      preferBelow: isHanging,
      child: textRow,
    );
  }
}
