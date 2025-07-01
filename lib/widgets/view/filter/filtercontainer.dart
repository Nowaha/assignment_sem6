import 'package:assignment_sem6/widgets/collapsible/collapsiblecontainer.dart';
import 'package:assignment_sem6/widgets/input/groupinput.dart';
import 'package:assignment_sem6/widgets/view/filter/filter.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:assignment_sem6/widgets/view/filter/locationfilter.dart';
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 16,
    children: [
      SearchWidget(
        onSearch:
            (value) => onFilterApplied(filters.copyWith(searchQuery: value)),
      ),
      SizedBox(
        width: double.infinity,
        child: CollapsibleContainer(
          title: "Date Range",
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StartEndSelector(
              start: filters.startDate,
              end: filters.endDate,
              onStartSelected:
                  (newStart) =>
                      onFilterApplied(filters.copyWith(startDate: newStart)),
              onEndSelected:
                  (newEnd) =>
                      onFilterApplied(filters.copyWith(endDate: newEnd)),
              onRangeSelected:
                  (newRange) => onFilterApplied(
                    filters.copyWith(
                      startDate: newRange.start,
                      endDate: newRange.end,
                    ),
                  ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: CollapsibleContainer(
          title: "Location",
          initiallyCollapsed: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LocationFilter(
              locationRect: filters.locationRect,
              updateLocation:
                  (newLocationRect) => onFilterApplied(
                    filters.copyWithLocation(newLocationRect),
                  ),
            ),
          ),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: CollapsibleContainer(
          title: "Groups",
          initiallyCollapsed: true,
          child: GroupInput(
            selectedGroups: filters.groups,
            onChanged:
                (newGroups) =>
                    onFilterApplied(filters.copyWith(groups: newGroups)),
          ),
        ),
      ),
      SizedBox(width: double.infinity, child: FilterWidget()),
    ],
  );
}
