import 'package:flutter/material.dart';

abstract class TimelineItem {
  final String name;
  final Color color;
  late final int startTimestamp;
  late final int endTimestamp;
  late final int rawLayer;
  final double layerOffset;

  int get count;

  late final double effectiveLayer;

  TimelineItem({
    required this.name,
    this.color = Colors.purple,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.rawLayer,
    this.layerOffset = 0,
  }) {
    effectiveLayer = rawLayer + layerOffset;
  }

  TimelineItem copyWith({int? rawLayer, double? layerOffset});
}
