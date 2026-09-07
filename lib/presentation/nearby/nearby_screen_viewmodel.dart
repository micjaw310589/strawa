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
  bool _pendingReload = false;
  int _activeRequestId = 0;

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

    if (_isLoading) {
      // Jeśli zapytanie trwa, oznaczamy konieczność ponowienia z nowym promieniem
      _pendingReload = true;
    } else {
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

    await _executeFetch();
  }

  Future<void> _executeFetch() async {
    final int requestId = ++_activeRequestId;

    try {
      _currentPosition = await _locationService.determinePosition();
      final double queryRadius = _radiusInMeters;

      final results = await _osmRestaurantService.getNearbyRestaurants(
        userLat: _currentPosition!.latitude,
        userLng: _currentPosition!.longitude,
        radiusInMeters: queryRadius,
      );

      // Jeśli w międzyczasie zmieniono promień, ignorujemy wynik tego zapytania
      if (requestId != _activeRequestId || _pendingReload) return;

      _allNearby = results;
      filterBySearchText(_searchQuery);
    } catch (e) {
      if (requestId != _activeRequestId || _pendingReload) return;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      if (requestId == _activeRequestId) {
        if (_pendingReload) {
          // Natychmiastowe uruchomienie kolejki bez gaszenia wskaźnika ładowania
          _pendingReload = false;
          await _executeFetch();
        } else {
          _isLoading = false;
          notifyListeners();
        }
      }
    }
  }

  void selectRestaurantOffers(String restaurantName) {
    _productService.filters = _productService.filters.copyWith(
      chains: [restaurantName],
    );
  }

  void selectAllNearbyOffers() {
    final names = _filteredRestaurants.map((r) => r.name).toSet().toList();
    _productService.filters = _productService.filters.copyWith(
      chains: names,
    );
  }
}