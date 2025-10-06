// import 'package:etqan_edu_app/core/utils/console_log_functions.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationUtils {
//   static Future<String?> getCurrentCountry() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return null;
//     }

//     // Check for location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return null;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return null;
//     }

//     // Get current position
//     Position position = await Geolocator.getCurrentPosition(
//       locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
//     );

//     // Reverse geocode to get country
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//       position.latitude,
//       position.longitude,
//     );

//     if (placemarks.isNotEmpty) {
//       logInfo("Country: ${placemarks.first.country}");
//       return placemarks.first.country;
//     }
//     return null;
//   }
// }
