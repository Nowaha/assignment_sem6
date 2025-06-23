import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimappostpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineMinimapZoom extends StatefulWidget {
  final TimelineController controller;
  final double width;
  final double height;
  final bool visible;

  const TimelineMinimapZoom({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    this.visible = true,
  });

  @override
  State<StatefulWidget> createState() => _TimelineMinimapZoomState();
}

class _TimelineMinimapZoomState extends State<TimelineMinimapZoom> {
  final List<TimelineItem> _filtered = [];
  int _firstTimestamp = -1;
  int _lastTimestamp = -1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(filter);
    filter();
  }

  @override
  void dispose() {
    widget.controller.removeListener(filter);
    super.dispose();
  }

  void filter() {
    List<TimelineItem> filtered = [];

    int firstTimestamp = -1;
    int lastTimestamp = -1;

    for (final item in widget.controller.items) {
      if (item.endTimestamp <= widget.controller.visibleStartTimestamp ||
          item.startTimestamp >= widget.controller.visibleEndTimestamp) {
        continue;
      }

      filtered.add(item);

      if (item.startTimestamp < firstTimestamp || firstTimestamp == -1) {
        firstTimestamp = item.startTimestamp;
      }

      if (item.endTimestamp > lastTimestamp || lastTimestamp == -1) {
        lastTimestamp = item.endTimestamp;
      }
    }

    _filtered.clear();
    _filtered.addAll(filtered);

    setState(() {
      _firstTimestamp = firstTimestamp;
      _lastTimestamp = lastTimestamp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (!widget.visible) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: isDarkMode ? Colors.white30 : Colors.black45),
      ),
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: TimelineMinimapPostPainter(
          items: _filtered,
          startTimestamp: _firstTimestamp,
          endTimestamp: _lastTimestamp,
          timelineColor:
              isDarkMode ? Theme.of(context).colorScheme.primary : Colors.black,
        ),
      ),
    );
  }
}
