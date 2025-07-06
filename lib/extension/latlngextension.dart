import 'package:latlong2/latlong.dart';

extension LatLngExtension on LatLng {
  LatLng correctDigits() {
    return LatLng(
      double.parse(latitude.toStringAsFixed(4)),
      double.parse(longitude.toStringAsFixed(4)),
    );
  }
}
