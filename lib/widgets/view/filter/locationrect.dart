class LocationRect {
  final double north;
  final double east;
  final double south;
  final double west;

  const LocationRect({
    required this.north,
    required this.east,
    required this.south,
    required this.west,
  });

  bool contains(double latitude, double longitude) {
    final inLat = latitude >= south && latitude <= north;
    final inLng =
        west <= east
            ? longitude >= west && longitude <= east
            : longitude >= west || longitude <= east;
    return inLat && inLng;
  }
}
