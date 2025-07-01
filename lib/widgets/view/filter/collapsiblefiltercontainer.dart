import 'package:assignment_sem6/widgets/collapsible/collapsiblecontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filtercontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:flutter/material.dart';

class CollapsibleFilterContainer extends StatelessWidget {
  final Filters filters;
  final void Function(Filters newFilters) onFilterApplied;

  const CollapsibleFilterContainer({
    super.key,
    required this.filters,
    required this.onFilterApplied,
  });

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
    child: CollapsibleContainer(
      title: "Search & Filters",
      backgroundColor: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: FilterContainer(
          filters: filters,
          onFilterApplied: onFilterApplied,
        ),
      ),
    ),
  );
}
