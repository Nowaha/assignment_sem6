import 'package:flutter/material.dart';

extension CanvasExtension on Canvas {
  void drawShadowOfLine(
    Offset p1,
    Offset p2,
    Paint paint, {
    ShadowOptions? shadowOptions,
  }) {
    final options = shadowOptions ?? ShadowOptions();

    Paint shadowPaint =
        Paint.from(paint)
          ..color = options.shadowColor
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, options.shadowBlur);
    drawLine(
      p1.translate(options.shadowOffset.dx, options.shadowOffset.dy),
      p2.translate(options.shadowOffset.dx, options.shadowOffset.dy),
      shadowPaint,
    );
  }

  void drawLineWithShadow(
    Offset p1,
    Offset p2,
    Paint paint, {
    ShadowOptions? shadowOptions,
  }) {
    drawShadowOfLine(p1, p2, paint, shadowOptions: shadowOptions);
    drawLine(p1, p2, paint);
  }
}

class ShadowOptions {
  final Offset shadowOffset;
  final Color shadowColor;
  final int shadowAlpha;
  final double shadowBlur;

  ShadowOptions({
    this.shadowOffset = const Offset(4, 4),
    Color? shadowColor,
    this.shadowAlpha = 200,
    this.shadowBlur = 4,
  }) : shadowColor = shadowColor ?? Colors.black.withAlpha(shadowAlpha);
}
