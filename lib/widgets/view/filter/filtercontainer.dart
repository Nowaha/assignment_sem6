import 'package:assignment_sem6/widgets/collapsible/collapsiblecontainer.dart';
import 'package:assignment_sem6/widgets/view/filter/filter.dart';
import 'package:assignment_sem6/widgets/view/filter/search.dart';
import 'package:assignment_sem6/widgets/view/filter/startend.dart';
import 'package:flutter/material.dart';

class FilterContainer extends StatefulWidget {
  const FilterContainer({super.key});

  @override
  State<StatefulWidget> createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
  final DateTime _initialStartDate = DateTime.now().subtract(
    const Duration(days: 1),
  );
  final DateTime _initialEndDate = DateTime.now().add(const Duration(days: 1));
  DateTime _selectedStartDate = DateTime.now().subtract(
    const Duration(days: 1),
  );
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 1));

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
          SearchWidget(),
          CollapsibleContainer(
            title: "Date Range",
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: StartEndSelector(
                start: _selectedStartDate,
                end: _selectedEndDate,
                onStartSelected:
                    (newStart) => setState(() {
                      _selectedStartDate = newStart;
                    }),
                onEndSelected:
                    (newEnd) => setState(() {
                      _selectedEndDate = newEnd;
                    }),
              ),
            ),
          ),
          FilterWidget(),
        ],
      ),
    ),
  );
}
