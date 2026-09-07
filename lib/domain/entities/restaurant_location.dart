class RestaurantLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? street;
  final String? houseNumber;
  final String? city;
  final String? postalCode;
  final double distanceInMeters;

  const RestaurantLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.street,
    this.houseNumber,
    this.city,
    this.postalCode,
    this.distanceInMeters = 0.0,
  });

  /// Zwraca czytelny, sformatowany adres
  String get formattedAddress {
    final parts = <String>[];
    if (street != null && street!.isNotEmpty) {
      if (houseNumber != null && houseNumber!.isNotEmpty) {
        parts.add('$street $houseNumber');
      } else {
        parts.add(street!);
      }
    }
    final cityPart = <String>[];
    if (postalCode != null && postalCode!.isNotEmpty) {
      cityPart.add(postalCode!);
    }
    if (city != null && city!.isNotEmpty) {
      cityPart.add(city!);
    }
    if (cityPart.isNotEmpty) {
      parts.add(cityPart.join(' '));
    }

    return parts.isEmpty ? 'Brak dokładnego adresu' : parts.join(', ');
  }

  /// Zwraca sformatowany dystans (np. "350 m" lub "1.4 km")
  String get formattedDistance {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
  }

  RestaurantLocation copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? street,
    String? houseNumber,
    String? city,
    String? postalCode,
    double? distanceInMeters,
  }) {
    return RestaurantLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      street: street ?? this.street,
      houseNumber: houseNumber ?? this.houseNumber,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
    );
  }

factory RestaurantLocation.fromOsmJson(
    Map<String, dynamic> json, {
    List<String> chainNames = const [],
  }) {
    final tags = (json['tags'] as Map<String, dynamic>?) ?? {};
    
    // Jeśli obiekt nie ma "name", pobieramy wartość z "brand"
    final rawName = (tags['name'] as String?)?.trim() ?? 
                    (tags['brand'] as String?)?.trim() ?? 
                    'Restauracja';

    String canonicalName = rawName;
    for (final chain in chainNames) {
      final brandTag = (tags['brand'] as String?)?.toLowerCase() ?? '';
      if (rawName.toLowerCase().contains(chain.toLowerCase()) || brandTag.contains(chain.toLowerCase())) {
        canonicalName = chain;
        break;
      }
    }

    double lat = 0.0;
    double lon = 0.0;
    if (json.containsKey('lat') && json.containsKey('lon')) {
      lat = (json['lat'] as num).toDouble();
      lon = (json['lon'] as num).toDouble();
    } else if (json.containsKey('center')) {
      lat = (json['center']['lat'] as num).toDouble();
      lon = (json['center']['lon'] as num).toDouble();
    }

    return RestaurantLocation(
      id: json['id'].toString(),
      name: canonicalName,
      latitude: lat,
      longitude: lon,
      street: tags['addr:street'] as String?,
      houseNumber: tags['addr:housenumber'] as String?,
      city: tags['addr:city'] as String?,
      postalCode: tags['addr:postcode'] as String?,
    );
  }
}