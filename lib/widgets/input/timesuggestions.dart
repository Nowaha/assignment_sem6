import 'package:flutter/material.dart';

class TimeSuggestions extends StatelessWidget {
  final void Function(DateTimeRange) onRangeSelected;

  const TimeSuggestions({super.key, required this.onRangeSelected});

  @override
  Widget build(BuildContext context) => Row(
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
  );
}
