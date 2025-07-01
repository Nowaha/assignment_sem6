import 'package:assignment_sem6/util/date.dart';
import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime?> onDateSelected;
  final bool clearable;

  const DateSelector({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.minDate,
    this.maxDate,
    this.clearable = false,
  });

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: minDate ?? DateTime(2000),
      lastDate: maxDate ?? DateTime(2100),
    );

    if (date == null) return;

    // Pick time
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
      initialEntryMode: TimePickerEntryMode.input,
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
          text:
              selectedDate != null
                  ? DateUtil.formatDateTime(
                    selectedDate!.millisecondsSinceEpoch,
                    false,
                  )
                  : "",
        ),
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child:
                !clearable
                    ? Icon(Icons.calendar_today)
                    : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        onDateSelected(null);
                      },
                    ),
          ),
        ),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
