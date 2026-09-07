import 'package:flutter/material.dart';
import 'package:strawa/domain/entities/restaurant_location.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantTileView extends StatelessWidget {
  final RestaurantLocation restaurant;
  final VoidCallback onSearchOffers;

  const RestaurantTileView({
    super.key,
    required this.restaurant,
    required this.onSearchOffers,
  });

  Future<void> _openNavigation() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double relativeWidth = MediaQuery.sizeOf(context).width * 0.95;

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: relativeWidth,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 51),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ikona w stylistyce kontenera zdjęcia z ProductTile
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.deepOrange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          restaurant.formattedAddress,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dystans ostylowany identycznie jak tagi w ProductTile
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepOrange[200]!),
                    ),
                    child: Text(
                      restaurant.formattedDistance,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openNavigation,
                      icon: const Icon(Icons.navigation, size: 16),
                      label: const Text('Nawiguj'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.amber[300]!),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSearchOffers,
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text('Oferta'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}