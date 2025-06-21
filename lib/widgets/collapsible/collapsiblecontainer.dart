import 'package:assignment_sem6/widgets/collapsible/collapsiblewithheader.dart';
import 'package:flutter/material.dart';

class CollapsibleContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyCollapsed;

  const CollapsibleContainer({
    super.key,
    required this.title,
    required this.child,
    this.initiallyCollapsed = false,
  });

  @override
  State<StatefulWidget> createState() => _CollapsibleContainerState();
}

class _CollapsibleContainerState extends State<CollapsibleContainer> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withAlpha(_isCollapsed ? 126 : 255),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CollapsibleWithHeader(
        title: widget.title,
        initiallyCollapsed: widget.initiallyCollapsed,
        child: widget.child,
        onCollapseChanged: (isCollapsed) {
          setState(() {
            _isCollapsed = isCollapsed;
          });
        },
      ),
    ),
  );
}
