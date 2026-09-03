import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:strawa/domain/entities/restaurant_location.dart';

class OsmRestaurantRepository {
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<RestaurantLocation>> fetchNearbyRestaurants({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
  }) async {
    // Zapytanie Overpass QL: szukamy węzłów i obiektów oznaczonych jako lokale gastronomiczne
    final query = '''
      [out:json][timeout:15];
      (
        node["amenity"~"restaurant|fast_food|cafe"]["name"](around:$radiusInMeters,$latitude,$longitude);
        way["amenity"~"restaurant|fast_food|cafe"]["name"](around:$radiusInMeters,$latitude,$longitude);
      );
      out center 50;
    ''';

    final response = await http.post(
      Uri.parse(_overpassUrl),
      body: {'data': query},
      headers: {'Accept': 'application/json'},
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final elements = decoded['elements'] as List<dynamic>? ?? [];

      return elements
          .map((item) => RestaurantLocation.fromOsmJson(item as Map<String, dynamic>))
          .where((r) => r.name.trim().isNotEmpty && r.latitude != 0.0 && r.longitude != 0.0)
          .toList();
    } else {
      throw Exception('Błąd pobierania danych z OpenStreetMap (kod: ${response.statusCode})');
    }
  }
}