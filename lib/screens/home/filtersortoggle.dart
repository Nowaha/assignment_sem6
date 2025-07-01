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
  Widget build(BuildContext context) => Positioned(
    left: 16,
    top: 16,
    child:
        ScreenUtil(context).isBigScreen
            ? CollapsibleFilterContainer(
              filters: filters,
              onFilterApplied: filterUpdate,
            )
            : IconButton.filled(
              onPressed: openFullscreenFilters,
              icon: Icon(Icons.search),
            ),
  );
}
