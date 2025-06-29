import 'package:assignment_sem6/util/date.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String label;
  final DateTime initialDateTime;
  final DateTime selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.label,
    required this.initialDateTime,
    required this.selectedDate,
    required this.onDateSelected,
    this.minDate,
    this.maxDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: minDate ?? DateTime(2000),
      lastDate: maxDate ?? DateTime(2100),
    );

    if (date == null) return;

    // Pick time
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    if (time == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    onDateSelected(combined);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: TextEditingController(
          text: DateUtil.formatDateTime(
            selectedDate.millisecondsSinceEpoch,
            false,
          ),
        ),
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
