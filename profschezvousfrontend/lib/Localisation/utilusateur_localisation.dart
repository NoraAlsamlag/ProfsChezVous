import 'package:geolocator/geolocator.dart';

Future<Map<String, double>?> getCurrentLocation() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Please enable location services';
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission denied permanently';
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Extract latitude and longitude
    double latitude = position.latitude;
    double longitude = position.longitude;
    print('longitude : $longitude latitude : $latitude');
    // Return coordinates as a Map<String, double>
    return {'latitude': latitude, 'longitude': longitude};
  } catch (e) {
    print('Error getting location: $e');
    // Return default values in case of error
    return null;
  }
}
