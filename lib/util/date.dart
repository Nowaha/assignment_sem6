class DateUtil {
  static const List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  static String formatDate(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${time.day.toString().padLeft(2, "0")} ${months[time.month - 1]} ${time.year}";
  }

  static String formatTime(int timestamp, bool includeSeconds) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hours = time.hour.toString().padLeft(2, "0");
    final minutes = time.minute.toString().padLeft(2, "0");

    if (includeSeconds) {
      final seconds = time.second.toString().padLeft(2, "0");
      return "$hours:$minutes:$seconds";
    }

    return "$hours:$minutes";
  }
}
