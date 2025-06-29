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
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isCollapsed ? SizedBox.shrink() : child,
        ),
      ],
    );
  }
}
