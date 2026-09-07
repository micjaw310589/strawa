import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Sprawdza i żąda uprawnień lokalizacji, a następnie zwraca pozycję GPS.
  Future<Position> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Uprawnienia do lokalizacji zostały odrzucone.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Uprawnienia do lokalizacji są trwale zablokowane. Włącz je w ustawieniach telefonu.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  /// Oblicza dystans w metrach między dwoma punktami geograficznymi
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}