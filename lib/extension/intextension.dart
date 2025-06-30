extension IntExtension on int {
  String toTwoDigits() {
    return toString().padLeft(2, "0");
  }
}
