import 'package:assignment_sem6/widgets/view/filter/filter.dart';
import 'package:assignment_sem6/widgets/view/filter/search.dart';
import 'package:flutter/material.dart';

class FilterContainer extends StatelessWidget {
  const FilterContainer({super.key});

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            "Search & Filters",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SearchWidget(),
          FilterWidget(),
        ],
      ),
    ),
  );
}
