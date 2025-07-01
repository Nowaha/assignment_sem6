import 'package:assignment_sem6/widgets/slidevisibility.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
import 'package:assignment_sem6/widgets/view/filter/fullscreenfilters.dart';
import 'package:flutter/widgets.dart';

class FullscreenFiltersDisplay extends StatelessWidget {
  final bool visible;
  final Filters filters;
  final Function(Filters) filterUpdate;
  final VoidCallback close;

  const FullscreenFiltersDisplay({
    super.key,
    required this.visible,
    required this.filters,
    required this.filterUpdate,
    required this.close,
  });

  @override
  Widget build(BuildContext context) => SlideVisibility(
    visible: visible,
    child: FullscreenFilters(
      filters: filters,
      onFilterApplied: filterUpdate,
      close: close,
    ),
  );
}
