import 'package:assignment_sem6/widgets/collapsible/collapsiblewithheader.dart';
import 'package:flutter/material.dart';

class CollapsibleContainer extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyCollapsed;
  final Color? backgroundColor;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final BoxDecoration? decoration;
  final List<BoxShadow>? boxShadow;

  const CollapsibleContainer({
    super.key,
    required this.title,
    required this.child,
    this.initiallyCollapsed = false,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.decoration,
    this.boxShadow,
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
        color: (widget.backgroundColor ??
                Theme.of(context).colorScheme.secondaryContainer)
            .withAlpha(_isCollapsed ? 126 : 255),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        border: widget.border,
        boxShadow: !_isCollapsed ? widget.boxShadow : null,
      ),
      child: CollapsibleWithHeader.textTitle(
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
