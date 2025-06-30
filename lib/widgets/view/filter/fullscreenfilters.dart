import 'package:assignment_sem6/widgets/screen.dart';
import 'package:assignment_sem6/widgets/view/filter/filtercontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filters.dart';
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
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: close),
    child: FilterContainer(filters: filters, onFilterApplied: onFilterApplied),
  );
}
