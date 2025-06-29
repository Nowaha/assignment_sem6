import 'package:assignment_sem6/widgets/view/filter/dateselector.dart';
import 'package:flutter/material.dart';

class StartEndSelector extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final ValueChanged<DateTime> onStartSelected;
  final ValueChanged<DateTime> onEndSelected;

  const StartEndSelector({
    super.key,
    required this.start,
    required this.end,
    required this.onStartSelected,
    required this.onEndSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        DateSelector(
          label: "Start Date",
          initialDateTime: start,
          selectedDate: start,
          maxDate: end,
          onDateSelected: onStartSelected,
        ),
        DateSelector(
          label: "End Date",
          initialDateTime: end,
          selectedDate: end,
          minDate: start,
          onDateSelected: onEndSelected,
        ),
      ],
    );
  }
}
