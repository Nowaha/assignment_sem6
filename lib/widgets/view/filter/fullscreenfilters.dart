import 'package:assignment_sem6/allinputscrollbehavior.dart';
import 'package:assignment_sem6/widgets/input/dateselector.dart';
import 'package:assignment_sem6/widgets/input/timesuggestions.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:assignment_sem6/widgets/view/filter/locationfilter.dart';
import 'package:assignment_sem6/widgets/view/filter/search.dart';
import 'package:flutter/material.dart';

class FullscreenFilters extends StatelessWidget {
  final Filters filters;
  final void Function(Filters newFilters) onFilterApplied;
  final VoidCallback close;

  const FullscreenFilters({
    super.key,
    required this.filters,
    required this.onFilterApplied,
    required this.close,
  });

  @override
  Widget build(BuildContext context) => Screen.scroll(
    title: Text("Filters"),
    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
    leading: IconButton(icon: const Icon(Icons.close), onPressed: close),
    child: Column(
      spacing: 16.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchWidget(
          onSearch:
              (value) => onFilterApplied(filters.copyWith(searchQuery: value)),
        ),
        Text("Date Range", style: Theme.of(context).textTheme.titleMedium),
        DateSelector(
          label: "Start Date",
          selectedDate: filters.startDate,
          maxDate: filters.endDate,
          onDateSelected: (start) {
            onFilterApplied(filters.copyWith(startDate: start));
          },
        ),
        DateSelector(
          label: "End Date",
          selectedDate: filters.endDate,
          minDate: filters.startDate,
          onDateSelected: (end) {
            onFilterApplied(filters.copyWith(endDate: end));
          },
        ),
        ScrollConfiguration(
          behavior: AllInputScrollBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: TimeSuggestions(
              onRangeSelected: (range) {
                onFilterApplied(
                  filters.copyWith(startDate: range.start, endDate: range.end),
                );
              },
            ),
          ),
        ),
        SizedBox(),
        Text("Location", style: Theme.of(context).textTheme.titleMedium),
        LocationFilter(
          locationRect: filters.locationRect,
          updateLocation:
              (newLocationRect) =>
                  onFilterApplied(filters.copyWithLocation(newLocationRect)),
        ),
      ],
    ),
  );
}
