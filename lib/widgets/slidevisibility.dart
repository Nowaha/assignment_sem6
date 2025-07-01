import 'package:flutter/material.dart';

class SlideVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;

  const SlideVisibility({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AnimatedSlide(
    offset: visible ? Offset(0, 0) : Offset(1, 0),
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOut,
    child: child,
  );
}
