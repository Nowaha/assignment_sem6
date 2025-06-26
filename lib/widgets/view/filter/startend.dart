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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateSelector(
          initialDateTime: start,
          selectedDate: start,
          onDateSelected: onStartSelected,
        ),
        DateSelector(
          initialDateTime: end,
          selectedDate: end,
          onDateSelected: onEndSelected,
        ),
      ],
    );
  }
}
