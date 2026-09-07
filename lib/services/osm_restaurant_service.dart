import 'package:strawa/domain/entities/restaurant_location.dart';
import 'package:strawa/domain/repositories/osm_restaurant_repository.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/services/chain_service.dart';
import 'package:strawa/services/location_service.dart';

class OsmRestaurantService {
  final _repository = locator<OsmRestaurantRepository>();
  final _locationService = locator<LocationService>();
  final _chainService = locator<ChainService>();

  Future<List<RestaurantLocation>> getNearbyRestaurants({
    required double userLat,
    required double userLng,
    required double radiusInMeters,
  }) async {
    // Pobranie nazw sieci z Twojej bazy danych Supabase
    final chainNames = await _chainService.getChainNames();
    if (chainNames.isEmpty) {
      return [];
    }

    final list = await _repository.fetchNearbyRestaurants(
      latitude: userLat,
      longitude: userLng,
      radiusInMeters: radiusInMeters,
      chainNames: chainNames,
    );

    // Obliczenie dystansu od pozycji telefonu i posortowanie rosnąco
    final calculatedList = list.map((r) {
      final distance = _locationService.calculateDistance(
        userLat,
        userLng,
        r.latitude,
        r.longitude,
      );
      return r.copyWith(distanceInMeters: distance);
    }).toList();

    calculatedList.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));
    return calculatedList;
  }
}