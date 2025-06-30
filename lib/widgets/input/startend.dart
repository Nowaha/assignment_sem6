import 'package:assignment_sem6/widgets/input/dateselector.dart';
import 'package:flutter/material.dart';

class StartEndSelector extends StatelessWidget {
  final DateTime? start;
  final String? startLabel;
  final bool startClearable;
  final String? endLabel;
  final DateTime? end;
  final bool endClearable;
  final bool suggestions;
  final ValueChanged<DateTime?> onStartSelected;
  final ValueChanged<DateTime?> onEndSelected;
  final ValueChanged<DateTimeRange> onRangeSelected;

  const StartEndSelector({
    super.key,
    required this.start,
    this.startLabel,
    this.startClearable = false,
    required this.end,
    this.endLabel,
    this.endClearable = false,
    this.suggestions = true,
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
              label: startLabel ?? "Start Date",
              selectedDate: start,
              maxDate: end,
              onDateSelected: onStartSelected,
              clearable: startClearable,
            ),
            DateSelector(
              label: endLabel ?? "End Date",
              selectedDate: end,
              minDate: start,
              onDateSelected: onEndSelected,
              clearable: endClearable,
            ),
          ],
        ),
        if (suggestions)
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
                      start: now.subtract(const Duration(days: 1)),
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
