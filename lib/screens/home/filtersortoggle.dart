import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/widgets/view/filter/collapsiblefiltercontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:flutter/material.dart';

class FiltersOrToggle extends StatelessWidget {
  final Filters filters;
  final Function(Filters) filterUpdate;
  final VoidCallback openFullscreenFilters;

  const FiltersOrToggle({
    super.key,
    required this.filters,
    required this.filterUpdate,
    required this.openFullscreenFilters,
  });

  @override
  Widget build(BuildContext context) =>
      ScreenUtil(context).isBigScreen
          ? Positioned(
            left: 16,
            top: 16,
            child: CollapsibleFilterContainer(
              filters: filters,
              onFilterApplied: filterUpdate,
            ),
          )
          : Positioned(
            bottom: 132,
            right: 20,
            child: SizedBox(
              width: 48,
              height: 48,
              child: FloatingActionButton(
                onPressed: openFullscreenFilters,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                tooltip: "Filters",
                elevation: 2,
                child: Icon(Icons.search, size: 22),
              ),
            ),
          );
}
