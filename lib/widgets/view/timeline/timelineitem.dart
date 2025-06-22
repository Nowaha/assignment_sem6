import 'package:flutter/material.dart';

class TimelineItem {
  final int startTimestamp;
  final int endTimestamp;
  final String name;
  final double height;
  final double width;
  final int layer;
  final Color color;

  const TimelineItem({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.name,
    required this.height,
    required this.width,
    this.color = Colors.purple,
    this.layer = 0,
  });
}
