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

  static String formatDateShort(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${time.day.toString().padLeft(2, "0")}/${time.month.toString().padLeft(2, "0")}/${time.year}";
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

  static String formatDateTime(int timestamp, bool includeSeconds) {
    final date = formatDate(timestamp);
    final time = formatTime(timestamp, includeSeconds);
    return "$date, $time";
  }

  static String formatDateTimeShort(int timestamp, bool includeSeconds) {
    final date = formatDateShort(timestamp);
    final time = formatTime(timestamp, includeSeconds);
    return "$date $time";
  }
  
  static String formatInterval(int intervalMs) {
    final seconds = (intervalMs / 1000).floor();
    final minutes = (seconds / 60).floor();
    final hours = (minutes / 60).floor();

    String result = "";
    if (hours > 0) {
      result += '${hours}h ';
    }
    if (minutes % 60 > 0) {
      result += '${minutes % 60}m ';
    }
    if (seconds % 60 > 0) {
      result += '${seconds % 60}s';
    }
    if (result.isEmpty) {
      result = '0s';
    }
    return result.trim();
  }
}
