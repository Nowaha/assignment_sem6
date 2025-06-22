import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color darken(double factor) {
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness * (1 - factor)).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  Color lighten(double factor) {
    final hsl = HSLColor.fromColor(this);
    final lightened = hsl.withLightness(
      (hsl.lightness * (1 + factor)).clamp(0.0, 1.0),
    );
    return lightened.toColor();
  }
}
