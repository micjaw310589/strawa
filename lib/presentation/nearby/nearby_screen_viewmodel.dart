import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:strawa/domain/entities/restaurant_location.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';
import 'package:strawa/services/location_service.dart';
import 'package:strawa/services/osm_restaurant_service.dart';
import 'package:strawa/services/product_service.dart';

class NearbyScreenViewModel extends ChangeNotifier {
  final _navBarViewModel = locator<NavBarViewModel>();
  final _locationService = locator<LocationService>();
  final _osmRestaurantService = locator<OsmRestaurantService>();
  final _productService = locator<ProductService>();

  Position? _currentPosition;
  List<RestaurantLocation> _allNearby = [];
  List<RestaurantLocation> _filteredRestaurants = [];

  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  double _radiusInMeters = 5000.0; // Domyślnie 5 km

  NearbyScreenViewModel() {
    activate();
  }

  void activate() {
    _navBarViewModel.setActiveItem(NavBarItem.wOkolicy);
  }

  // Gettery
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get radiusInMeters => _radiusInMeters;
  List<RestaurantLocation> get restaurants => _filteredRestaurants;
  bool get hasSearched => _allNearby.isNotEmpty;
  String get searchQuery => _searchQuery;

  void setRadius(double radius) {
    if (_radiusInMeters == radius) return;
    _radiusInMeters = radius;
    notifyListeners();
    if (_currentPosition != null) {
      loadNearbyRestaurants();
    }
  }

  void filterBySearchText(String query) {
    _searchQuery = query;
    final lower = query.trim().toLowerCase();
    if (lower.isEmpty) {
      _filteredRestaurants = List.from(_allNearby);
    } else {
      _filteredRestaurants = _allNearby.where((r) {
        return r.name.toLowerCase().contains(lower) ||
            r.formattedAddress.toLowerCase().contains(lower);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> loadNearbyRestaurants() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentPosition = await _locationService.determinePosition();
      final results = await _osmRestaurantService.getNearbyRestaurants(
        userLat: _currentPosition!.latitude,
        userLng: _currentPosition!.longitude,
        radiusInMeters: _radiusInMeters,
      );
      _allNearby = results;
      filterBySearchText(_searchQuery);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectRestaurantOffers(String restaurantName) {
    _productService.filters = _productService.filters.copyWith(
      chains: [restaurantName],
    );
  }

  void selectAllNearbyOffers() {
    final names = _allNearby.map((r) => r.name).toSet().toList();
    _productService.filters = _productService.filters.copyWith(
      chains: names,
    );
  }
}