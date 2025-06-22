class SeekerInfo {
  static const double seekerHandleHeight = 8;
  static const double seekerHandleWidth = 4;

  final double seekerStart;
  final double seekerEnd;

  int get seekerMiddle => (seekerStart + seekerEnd) ~/ 2;

  int leftHandleEnd(double leniency) =>
      (seekerStart + (seekerHandleWidth / 2) + leniency).toInt();

  int rightHandleStart(double leniency) =>
      (seekerEnd - (seekerHandleWidth / 2) - leniency).toInt();

  bool isWithinSeeker(double x) {
    return x >= seekerStart + seekerHandleWidth &&
        x <= seekerEnd - seekerHandleWidth;
  }

  bool isWithinLeftHandle(double x, double leniency) {
    return x >= seekerStart - leniency &&
        x <= seekerStart + seekerHandleWidth + leniency;
  }

  bool isWithinRightHandle(double x, double leniency) {
    return x >= seekerEnd - seekerHandleWidth - leniency &&
        x <= seekerEnd + leniency;
  }

  const SeekerInfo({required this.seekerStart, required this.seekerEnd});

  const SeekerInfo.zero() : seekerStart = 0, seekerEnd = 0;
}
