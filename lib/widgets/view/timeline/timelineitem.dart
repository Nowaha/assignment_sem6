import 'package:flutter/material.dart';

class TimelineItem {
  final String name;
  final Color color;
  final int startTimestamp;
  final int endTimestamp;
  final double height;
  final double width;
  final int rawLayer;
  final double layerOffset;
  late final double effectiveLayer;

  TimelineItem({
    required this.name,
    this.color = Colors.purple,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.height,
    required this.width,
    this.rawLayer = 1,
    this.layerOffset = 0,
  }) {
    effectiveLayer = rawLayer + layerOffset;
  }

  TimelineItem copyWith({
    int? startTimestamp,
    int? endTimestamp,
    String? name,
    double? height,
    double? width,
    Color? color,
    int? rawLayer,
    double? layerOffset,
  }) {
    return TimelineItem(
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      name: name ?? this.name,
      height: height ?? this.height,
      width: width ?? this.width,
      color: color ?? this.color,
      rawLayer: rawLayer ?? this.rawLayer,
      layerOffset: layerOffset ?? this.layerOffset,
    );
  }
}
