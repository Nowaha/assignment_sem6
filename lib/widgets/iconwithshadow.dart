import 'package:flutter/material.dart';

class IconWithShadow extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final double shadowOffset;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;

  const IconWithShadow({
    Key? key,
    required this.icon,
    this.size = 24.0,
    this.color = Colors.black,
    this.shadowOffset = 2.0,
    this.shadowColor = Colors.grey,
    this.shadowBlurRadius = 4.0,
    this.shadowSpreadRadius = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(shadowOffset, shadowOffset),
            blurRadius: shadowBlurRadius,
            spreadRadius: shadowSpreadRadius,
          ),
        ],
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}
