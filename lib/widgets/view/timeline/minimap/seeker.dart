class SeekerInfo {
  static const double seekerHandleHeight = 8;
  static const double seekerHandleWidth = 4;

  final double seekerStartFraction;
  final double seekerEndFraction;

  double getSeekerStart(double width) => seekerStartFraction * width;
  double getSeekerEnd(double width) => seekerEndFraction * width;

  int get seekerMiddle => (seekerStartFraction + seekerEndFraction) ~/ 2;

  int leftHandleEnd(double width, double leniency) =>
      (getSeekerStart(width) + (seekerHandleWidth / 2) + leniency).toInt();

  int rightHandleStart(double width, double leniency) =>
      (getSeekerEnd(width) - (seekerHandleWidth / 2) - leniency).toInt();

  bool isWithinSeeker(double width, double x) {
    return x >= getSeekerStart(width) + seekerHandleWidth &&
        x <= getSeekerEnd(width) - seekerHandleWidth;
  }

  bool isWithinLeftHandle(double width, double x, double leniency) {
    return x >= getSeekerStart(width) - leniency &&
        x <= getSeekerStart(width) + seekerHandleWidth + leniency;
  }

  bool isWithinRightHandle(double width, double x, double leniency) {
    return x >= getSeekerEnd(width) - seekerHandleWidth - leniency &&
        x <= getSeekerEnd(width) + leniency;
  }

  const SeekerInfo({
    required this.seekerStartFraction,
    required this.seekerEndFraction,
  });

  const SeekerInfo.zero() : seekerStartFraction = 0, seekerEndFraction = 0;
}
