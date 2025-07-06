class LocationUtil {
  static double latitudeFromString(String latitude) {
    final parsed = double.tryParse(latitude);
    if (parsed == null) {
      throw ArgumentError("Invalid latitude: $latitude");
    }
    return clampToValidLatitude(parsed);
  }

  static double longitudeFromString(String longitude) {
    final parsed = double.tryParse(longitude);
    if (parsed == null) {
      throw ArgumentError("Invalid longitude: $longitude");
    }
    return clampToValidLongitude(parsed);
  }

  static String latLonToString(double value) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError("Invalid latitude or longitude value: $value");
    }
    return value.toStringAsFixed(6).replaceAll(RegExp(r"\.?0+$"), "");
  }

  static double clampToValidLatitude(double latitude) {
    return double.parse(latLonToString(latitude.clamp(-90.0, 90.0)));
  }

  static double clampToValidLongitude(double longitude) {
    return double.parse(latLonToString(longitude.clamp(-180.0, 180.0)));
  }
}
