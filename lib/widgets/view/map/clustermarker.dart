import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ClusterMarker extends Marker {
  final int count;

  ClusterMarker({required super.point, this.count = 0})
    : super(
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        ),
      );
}
