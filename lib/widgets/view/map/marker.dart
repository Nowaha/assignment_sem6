import 'package:assignment_sem6/widgets/view/map/marketwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapMarker extends Marker {
  final Color color;
  final double size;

  MapMarker({required super.point, this.color = Colors.red, this.size = 24})
    : super(child: MarkerWidget(color: color, size: size));
}
