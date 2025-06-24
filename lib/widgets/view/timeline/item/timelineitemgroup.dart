import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineItemGroup extends TimelineItem {
  final List<TimelineItem> items;

  @override
  int get count => items.fold(0, (sum, item) => sum + item.count);

  TimelineItemGroup({
    required String name,
    Color color = Colors.blue,
    required List<TimelineItem> items,
    required int rawLayer,
    double? layerOffset,
  }) : this._withBounds(
         name: name,
         color: color,
         items: items,
         layerOffset: layerOffset,
         rawLayer: rawLayer,
         bounds: _Bounds.calculateBounds(items),
       );

  TimelineItemGroup._withStartEnd({
    required super.name,
    super.color,
    required this.items,
    required super.startTimestamp,
    required super.endTimestamp,
    required super.rawLayer,
    super.layerOffset,
  });

  TimelineItemGroup._withBounds({
    required super.name,
    super.color,
    required this.items,
    double? layerOffset,
    required super.rawLayer,
    required _Bounds bounds,
  }) : super(startTimestamp: bounds.start, endTimestamp: bounds.end);

  @override
  TimelineItemGroup copyWith({int? rawLayer, double? layerOffset}) {
    return TimelineItemGroup._withStartEnd(
      name: name,
      color: color,
      items: items,
      rawLayer: rawLayer ?? this.rawLayer,
      layerOffset: layerOffset ?? this.layerOffset,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
    );
  }

  TimelineItemGroup copyWithItems(List<TimelineItem> newItems) {
    return TimelineItemGroup(
      name: name,
      color: color,
      items: newItems,
      rawLayer: rawLayer,
      layerOffset: layerOffset,
    );
  }
}

class _Bounds {
  final int start;
  final int end;

  const _Bounds({required this.start, required this.end});

  static _Bounds calculateBounds(List<TimelineItem> items) {
    int? startTimestamp, endTimestamp;

    if (items.isNotEmpty) {
      for (final item in items) {
        if (startTimestamp == null || item.startTimestamp < startTimestamp) {
          startTimestamp = item.startTimestamp;
        }
        if (endTimestamp == null || item.endTimestamp > endTimestamp) {
          endTimestamp = item.endTimestamp;
        }
      }
    }

    return _Bounds(start: startTimestamp ?? 0, end: endTimestamp ?? 0);
  }
}
