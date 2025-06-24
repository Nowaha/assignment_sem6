import 'dart:ui';

import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:latlong2/latlong.dart';

class BasicTimelineItem extends TimelineItem {
  @override
  final int count = 1;

  BasicTimelineItem({
    required super.name,
    super.color,
    required super.location,
    required super.startTimestamp,
    required super.endTimestamp,
    required super.rawLayer,
    super.layerOffset,
  });

  @override
  BasicTimelineItem copyWith({
    int? startTimestamp,
    int? endTimestamp,
    String? name,
    Color? color,
    LatLng? location,
    int? rawLayer,
    double? layerOffset,
  }) {
    return BasicTimelineItem(
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      name: name ?? this.name,
      color: color ?? this.color,
      location: location ?? this.location,
      rawLayer: rawLayer ?? this.rawLayer,
      layerOffset: layerOffset ?? this.layerOffset,
    );
  }
}
