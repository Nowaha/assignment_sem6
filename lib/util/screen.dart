import 'package:flutter/widgets.dart';

class ScreenUtil {
  final BuildContext context;

  ScreenUtil(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;

  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  double get safeAreaTop => MediaQuery.of(context).padding.top;
  double get safeAreaBottom => MediaQuery.of(context).padding.bottom;
  double get safeAreaLeft => MediaQuery.of(context).padding.left;
  double get safeAreaRight => MediaQuery.of(context).padding.right;

  bool get isBigScreen => width > 600;
}
