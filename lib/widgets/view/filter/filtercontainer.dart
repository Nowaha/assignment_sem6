import 'package:assignment_sem6/widgets/collapsible/collapsiblecontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filter.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:assignment_sem6/widgets/view/filter/search.dart';
import 'package:assignment_sem6/widgets/input/startend.dart';
import 'package:flutter/material.dart';

class FilterContainer extends StatelessWidget {
  final Filters filters;
  final void Function(Filters newFilters) onFilterApplied;

  const FilterContainer({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          SearchWidget(
            onSearch:
                (value) =>
                    onFilterApplied(filters.copyWith(searchQuery: value)),
          ),
          CollapsibleContainer(
            title: "Date Range",
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: StartEndSelector(
                start: filters.startDate,
                end: filters.endDate,
                onStartSelected: (newStart) {
                  onFilterApplied(filters.copyWith(startDate: newStart));
                },
                onEndSelected: (newEnd) {
                  onFilterApplied(filters.copyWith(endDate: newEnd));
                },
                onRangeSelected: (newRange) {
                  onFilterApplied(
                    filters.copyWith(
                      startDate: newRange.start,
                      endDate: newRange.end,
                    ),
                  );
                },
              ),
            ),
          ),
          FilterWidget(),
        ],
      ),
    ),
  );
}
