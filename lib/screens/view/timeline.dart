import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatefulWidget {
  final int startTimestamp;
  final int endTimestamp;
  final int timeScale;
  final VoidCallback onMapButtonPressed;

  const TimelineView({
    super.key,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.timeScale,
    required this.onMapButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late final TimelineController _controller;

  @override
  void initState() {
    _controller = TimelineController.withTimeScale(
      items: [],
      startTimestamp: widget.startTimestamp,
      endTimestamp: widget.endTimestamp,
      timeScale: widget.timeScale,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Timeline(
      controller: _controller,
      onMapButtonPressed: widget.onMapButtonPressed,
    );
  }
}
