import 'package:flutter/material.dart';

class MarkerWidget extends StatefulWidget {
  final Color color;
  final double size;

  const MarkerWidget({super.key, this.color = Colors.red, this.size = 24});

  @override
  State<MarkerWidget> createState() => _MarkerWidgetState();
}

class _MarkerWidgetState extends State<MarkerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: widget.size * 0.6,
      ),
    );
  }
}
