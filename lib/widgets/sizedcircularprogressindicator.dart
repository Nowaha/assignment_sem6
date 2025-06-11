import 'package:flutter/material.dart';

class SizedCircularProgressIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  final double? strokeWidth;
  final bool onPrimary;

  const SizedCircularProgressIndicator({
    super.key,
    this.width,
    this.height,
    this.strokeWidth,
    this.onPrimary = false,
  });

  static SizedCircularProgressIndicator square({
    required double size,
    double? strokeWidth,
    bool onPrimary = false,
  }) => SizedCircularProgressIndicator(
    width: size,
    height: size,
    strokeWidth: strokeWidth,
    onPrimary: onPrimary,
  );

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: CircularProgressIndicator(
      strokeWidth: strokeWidth,
      color: onPrimary ? Theme.of(context).colorScheme.onPrimary : null,
    ),
  );
}
