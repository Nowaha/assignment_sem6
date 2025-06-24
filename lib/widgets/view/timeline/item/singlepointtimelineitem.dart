import 'dart:ui';

import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:latlong2/latlong.dart';

class SinglePointTimelineItem extends TimelineItem {
  @override
  final int count = 1;

  SinglePointTimelineItem({
    required super.name,
    super.color,
    required super.location,
    required int timestamp,
    required super.rawLayer,
    super.layerOffset,
  }) : super(startTimestamp: timestamp, endTimestamp: timestamp);

  @override
  SinglePointTimelineItem copyWith({
    int? timestamp,
    String? name,
    Color? color,
    LatLng? location,
    int? rawLayer,
    double? layerOffset,
  }) {
    return SinglePointTimelineItem(
      timestamp: timestamp ?? startTimestamp,
      name: name ?? this.name,
      location: location ?? this.location,
      color: color ?? this.color,
      rawLayer: rawLayer ?? this.rawLayer,
      layerOffset: layerOffset ?? this.layerOffset,
    );
  }
}
