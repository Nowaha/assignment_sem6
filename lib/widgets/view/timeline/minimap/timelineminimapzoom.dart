import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimappostpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelineMinimapZoom extends StatefulWidget {
  final double width;
  final double height;

  final double fullWidth;
  final bool visible;

  const TimelineMinimapZoom({
    super.key,
    required this.width,
    required this.height,
    required this.fullWidth,
    this.visible = true,
  });

  @override
  State<StatefulWidget> createState() => _TimelineMinimapZoomState();
}

class _TimelineMinimapZoomState extends State<TimelineMinimapZoom> {
  late final TimelineState _timelineState;
  final List<TimelineItem> _filtered = [];
  int _firstTimestamp = -1;
  int _lastTimestamp = -1;

  @override
  void initState() {
    super.initState();

    _timelineState = context.read<TimelineState>();
    _timelineState.addListener(filter);
    filter();
  }

  @override
  void dispose() {
    _timelineState.removeListener(filter);
    super.dispose();
  }

  void filter() {
    List<TimelineItem> filtered = [];

    int firstTimestamp = -1,
        backupFirstTimestamp = -1,
        lastTimestamp = -1,
        backupLastTimestamp = -1;

    for (final item in _timelineState.items) {
      if (item.endTimestamp <= _timelineState.visibleStartTimestamp ||
          item.startTimestamp >= _timelineState.visibleEndTimestamp) {
        continue;
      }

      filtered.add(item);

      bool fullyOnScreen =
          item.startTimestamp >= _timelineState.visibleStartTimestamp &&
          item.endTimestamp <= _timelineState.visibleEndTimestamp;

      if (fullyOnScreen) {
        if (item.startTimestamp < firstTimestamp || firstTimestamp == -1) {
          firstTimestamp = item.startTimestamp;
        }
        if (item.endTimestamp > lastTimestamp || lastTimestamp == -1) {
          lastTimestamp = item.endTimestamp;
        }
      } else {
        if (item.startTimestamp < backupFirstTimestamp ||
            backupFirstTimestamp == -1) {
          backupFirstTimestamp = item.startTimestamp;
        }
        if (item.endTimestamp > backupLastTimestamp ||
            backupLastTimestamp == -1) {
          backupLastTimestamp = item.endTimestamp;
        }
      }
    }

    _filtered.clear();
    _filtered.addAll(filtered);

    setState(() {
      _firstTimestamp =
          firstTimestamp != -1 ? firstTimestamp : backupFirstTimestamp;
      _lastTimestamp =
          lastTimestamp != -1 ? lastTimestamp : backupLastTimestamp;
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
        painter: TimelineMinimapPostPainter.zoom(
          items: _filtered,
          startTimestamp: _firstTimestamp,
          endTimestamp: _lastTimestamp,
          timelineColor:
              isDarkMode ? Theme.of(context).colorScheme.primary : Colors.black,
          timelineStart: _timelineState.visibleStartTimestamp,
          timelineEnd: _timelineState.visibleEndTimestamp,
          timelineWidth: widget.fullWidth,
        ),
      ),
    );
  }
}
