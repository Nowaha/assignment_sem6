import 'package:assignment_sem6/widgets/collapsible/collapsiblewithheader.dart';
import 'package:flutter/material.dart';

class CollapsibleContainer extends StatelessWidget {
  final Widget child;
  final String title;
  final bool initiallyCollapsed;

  const CollapsibleContainer({
    super.key,
    required this.child,
    required this.title,
    this.initiallyCollapsed = false,
  });

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CollapsibleWithHeader(
        title: title,
        initiallyCollapsed: initiallyCollapsed,
        child: child,
      ),
    ),
  );
}
