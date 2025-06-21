import 'package:assignment_sem6/widgets/collapsible/collapsible.dart';
import 'package:assignment_sem6/widgets/noeffectinkwell.dart';
import 'package:flutter/material.dart';

class CollapsibleWithHeader extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyCollapsed;
  final Function(bool)? onCollapseChanged;

  const CollapsibleWithHeader({
    super.key,
    required this.title,
    required this.child,
    this.initiallyCollapsed = false,
    this.onCollapseChanged,
  });

  @override
  State<StatefulWidget> createState() => _CollapsibleWithHeaderState();
}

class _CollapsibleWithHeaderState extends State<CollapsibleWithHeader> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });

    if (widget.onCollapseChanged != null) {
      widget.onCollapseChanged!(_isCollapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message:
                _isCollapsed
                    ? "Expand ${widget.title}"
                    : "Collapse ${widget.title}",
            child: NoEffectInkWell(
              onTap: _toggleCollapse,
              child: Row(
                spacing: 8,
                children: [
                  SizedBox.square(
                    dimension: 24,
                    child: IconButton(
                      onPressed: _toggleCollapse,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        _isCollapsed ? Icons.expand_more : Icons.expand_less,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Collapsible(
            isCollapsed: _isCollapsed,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
