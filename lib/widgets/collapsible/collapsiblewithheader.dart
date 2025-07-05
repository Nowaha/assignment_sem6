import 'package:assignment_sem6/widgets/collapsible/collapsible.dart';
import 'package:assignment_sem6/widgets/noeffectinkwell.dart';
import 'package:flutter/material.dart';

class CollapsibleWithHeader extends StatefulWidget {
  final String? title;
  final Widget? titleWidget;
  final bool containsError;
  final Widget child;
  final bool initiallyCollapsed;
  final Function(bool)? onCollapseChanged;
  final bool noIntrinsicWidth;

  const CollapsibleWithHeader._({
    super.key,
    required this.title,
    this.titleWidget,
    this.containsError = false,
    this.initiallyCollapsed = false,
    this.onCollapseChanged,
    this.noIntrinsicWidth = false,
    required this.child,
  });

  const CollapsibleWithHeader.textTitle({
    Key? key,
    required String title,
    Widget? child,
    bool containsError = false,
    bool initiallyCollapsed = false,
    Function(bool)? onCollapseChanged,
    bool noIntrinsicWidth = false,
  }) : this._(
         key: key,
         title: title,
         child: child ?? const SizedBox.shrink(),
         containsError: containsError,
         initiallyCollapsed: initiallyCollapsed,
         onCollapseChanged: onCollapseChanged,
         noIntrinsicWidth: noIntrinsicWidth,
       );

  const CollapsibleWithHeader.widgetTitle({
    Key? key,
    required Widget title,
    required String tooltip,
    Widget? child,
    bool containsError = false,
    bool initiallyCollapsed = false,
    Function(bool)? onCollapseChanged,
    bool noIntrinsicWidth = false,
  }) : this._(
         key: key,
         titleWidget: title,
         title: tooltip,
         child: child ?? const SizedBox.shrink(),
         containsError: containsError,
         initiallyCollapsed: initiallyCollapsed,
         onCollapseChanged: onCollapseChanged,
         noIntrinsicWidth: noIntrinsicWidth,
       );

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
  void didUpdateWidget(covariant CollapsibleWithHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.containsError && widget.containsError) {
      setState(() {
        _isCollapsed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final built = Column(
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
                      color:
                          widget.containsError
                              ? Theme.of(context).colorScheme.error
                              : null,
                    ),
                  ),
                ),
                Expanded(
                  child:
                      widget.titleWidget ??
                      RichText(
                        text: TextSpan(
                          text: widget.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color:
                                widget.containsError
                                    ? Theme.of(context).colorScheme.error
                                    : null,
                          ),
                          children:
                              widget.containsError
                                  ? [
                                    TextSpan(
                                      text: " (contains errors)",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ]
                                  : [],
                        ),
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
    );

    return widget.noIntrinsicWidth ? built : IntrinsicWidth(child: built);
  }
}
