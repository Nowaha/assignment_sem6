import 'package:flutter/material.dart';

class Collapsible extends StatelessWidget {
  final bool isCollapsed;
  final Widget child;

  const Collapsible({
    super.key,
    required this.isCollapsed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: const Duration(milliseconds: 100),
    curve: Curves.easeInOut,
    alignment: Alignment.topCenter,
    child: ClipRect(
      child: Align(
        alignment: Alignment.topLeft,
        heightFactor: isCollapsed ? 0.0 : 1.0,
        child: child,
      ),
    ),
  );
}
