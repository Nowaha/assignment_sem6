import 'package:flutter/material.dart';

class NoEffectInkWell extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const NoEffectInkWell({super.key, this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    child: child
  );
}
