class DateUtil {
  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String formatDate(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${time.day.toString().padLeft(2, '0')} ${months[time.month - 1]} ${time.year}';
  }
}
