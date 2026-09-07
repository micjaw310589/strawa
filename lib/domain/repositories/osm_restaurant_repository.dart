import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:strawa/domain/entities/restaurant_location.dart';

class OsmRestaurantRepository {
  // Stabilne, publiczne instancje Overpass API
  static const List<String> _endpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
  ];

  Future<List<RestaurantLocation>> fetchNearbyRestaurants({
    required double latitude,
    required double longitude,
    required double radiusInMeters,
    required List<String> chainNames,
  }) async {
    final validChains = chainNames.where((c) => c.trim().isNotEmpty).toList();
    if (validChains.isEmpty) {
      return [];
    }

    // Bezpieczne przygotowanie nazw sieci pod regex Overpass QL
    final regexPattern = validChains.map((name) {
      return name
          .replaceAll(r'\', r'\\')
          .replaceAll('"', r'\"')
          .replaceAllMapped(RegExp(r'[\^$*+?.()|[\]{}]'), (m) => '\\${m[0]}');
    }).join('|');

    // Kluczowe: ["amenity"~"..."] ogranicza przeszukiwanie do lokali gastro,
    // dzięki czemu Overpass korzysta z indeksu i nie analizuje milionów innych obiektów
    final query = '''
[out:json][timeout:15];
(
  node["amenity"~"restaurant|fast_food|cafe|bar"]["brand"~"$regexPattern", i](around:$radiusInMeters,$latitude,$longitude);
  way["amenity"~"restaurant|fast_food|cafe|bar"]["brand"~"$regexPattern", i](around:$radiusInMeters,$latitude,$longitude);
);
out center 50;
''';

    Exception? lastException;

    for (final endpoint in _endpoints) {
      try {
        final response = await http.post(
          Uri.parse(endpoint),
          body: {'data': query},
          headers: {
            'Accept': '*/*',
            'User-Agent': 'StrawaApp/1.0 (contact@strawa.app)',
          },
        ).timeout(const Duration(seconds: 20));

if (response.statusCode == 200) {
          final decoded = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

          // Overpass zwraca błędy limitu pamięci/czasu w polu "remark" przy kodzie 200
          if (decoded.containsKey('remark') && (decoded['elements'] as List? ?? []).isEmpty) {
            throw Exception('Serwer OSM przerwał zapytanie (timeout/pamięć). Spróbuj mniejszego promienia.');
          }

          final elements = decoded['elements'] as List<dynamic>? ?? [];

          return elements
              .map((item) => RestaurantLocation.fromOsmJson(
                    item as Map<String, dynamic>,
                    chainNames: validChains,
                  ))
              .where((r) => r.latitude != 0.0 && r.longitude != 0.0)
              .toList();
        } else {
          lastException = Exception('Błąd serwera OSM ($endpoint): kod ${response.statusCode}');
        }
      } catch (e) {
        lastException = Exception('Problem z połączeniem ($endpoint): $e');
      }
    }

    throw lastException ?? Exception('Nie udało się pobrać danych z OSM.');
  }
}