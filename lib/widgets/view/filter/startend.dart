import 'package:assignment_sem6/widgets/view/filter/dateselector.dart';
import 'package:flutter/material.dart';

class StartEndSelector extends StatelessWidget {
  final DateTime start;
  final DateTime end;
  final ValueChanged<DateTime> onStartSelected;
  final ValueChanged<DateTime> onEndSelected;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const StartEndSelector({
    super.key,
    required this.start,
    required this.end,
    required this.onStartSelected,
    required this.onEndSelected,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.0,
      children: [
        Row(
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
        ),
        Row(
          spacing: 8.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                final now = DateTime.now().copyWith(millisecond: 0);
                onRangeSelected(
                  DateTimeRange(
                    start: DateTime(now.year, now.month, now.day),
                    end: now,
                  ),
                );
              },
              child: const Text("Today"),
            ),
            OutlinedButton(
              onPressed: () {
                final now = DateTime.now().copyWith(millisecond: 0);
                onRangeSelected(
                  DateTimeRange(
                    start: DateTime(now.year, now.month, now.day - 1),
                    end: now,
                  ),
                );
              },
              child: const Text("24 hours"),
            ),
            OutlinedButton(
              onPressed: () {
                final now = DateTime.now().copyWith(millisecond: 0);
                onRangeSelected(
                  DateTimeRange(
                    start: now.subtract(const Duration(days: 3)),
                    end: now,
                  ),
                );
              },
              child: const Text("3 days"),
            ),
            OutlinedButton(
              onPressed: () {
                final now = DateTime.now().copyWith(millisecond: 0);
                onRangeSelected(
                  DateTimeRange(
                    start: now.subtract(const Duration(days: 7)),
                    end: now,
                  ),
                );
              },
              child: const Text("1 week"),
            ),
          ],
        ),
      ],
    );
  }
}
