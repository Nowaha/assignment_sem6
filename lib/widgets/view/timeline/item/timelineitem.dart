import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class TimelineItem {
  final String name;
  final String postUUID;
  final Color color;
  final LatLng location;
  late final int startTimestamp;
  late final int endTimestamp;
  late final int rawLayer;
  final double layerOffset;

  String get key => "item-$postUUID";

  late final double effectiveLayer;

  bool get isSinglePoint => endTimestamp == startTimestamp;
  bool get isEndless => endTimestamp == null;

  TimelineItem({
    required this.name,
    required this.postUUID,
    this.color = Colors.purple,
    required this.location,
    required this.startTimestamp,
    int? endTimestamp,
    required this.rawLayer,
    this.layerOffset = 0,
  }) {
    effectiveLayer = rawLayer + layerOffset;
    this.endTimestamp = endTimestamp ?? startTimestamp;
  }

  TimelineItem.fromPost(
    Post post, {
    Color? color,
    int layer = 0,
    double layerOffset = 0.0,
  }) : this(
         postUUID: post.uuid,
         startTimestamp: post.startTimestamp,
         endTimestamp: post.endTimestamp ?? post.startTimestamp,
         name: post.title,
         color: color ?? Colors.purple,
         location: LatLng(post.lat, post.lng),
         rawLayer: layer,
         layerOffset: layerOffset,
       );

  TimelineItem copyWith({
    String? postUUID,
    int? startTimestamp,
    int? endTimestamp,
    String? name,
    Color? color,
    LatLng? location,
    int? rawLayer,
    double? layerOffset,
  }) {
    return TimelineItem(
      postUUID: postUUID ?? this.postUUID,
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
